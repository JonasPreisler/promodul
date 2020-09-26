module Products
  class ImportProductsService
    attr_accessor :current_user, :params

    def initialize(current_user = nil, params = nil)
      #@current_user = current_user
      @params = params
      @errors ||= []
    end

    def create_and_call
      binding.pry
      Products::ImportProductsWorker.new.perform(params, 52)
      #Xlsx::ImportTransactionsWorker.perform_async(params, current_user.id)
    end

    def call
      binding.pry
      @file_path ||= params["excel"].tempfile
      imported_items = load_imported_items.as_json( only: [:"Our excel columns"])
      binding.pry
      #ToDo: Here should be Products Excel Type Enums(like: always24, Any Provider or something like this.)
      #@excel_type = BankType.find_by(id_name: params["file_type"])
      counter = 0
      #ToDo: Here should be some pars actions if we need, to build hash like object params.
      #imported_items.map { |obj| obj["account_number"] = obj["account_number"].delete_prefix("GEL").delete_suffix("GEL") }
      imported_items.each do |item|
        #ToDo: Here should be ImportedProducts model to create Object.
        object = ImportedProduct.new
        object.attributes = item
        object.current_user_id = @current_user.id
        object.excel_type_id = @excel_type&.id
        object.save!
        counter += 1
      rescue ActiveRecord::RecordNotUnique => e
        #ToDo: If catalog and imported products will be different objects, than Here we do not need this validation.
        @errors << I18n.t('excel_import.uniq_document_error', code: object.transaction_code)
        next
      end

      #ToDo: mailer(or notifier) to notify administrator
      #send_mail_to_current_user(counter)
      delete_file
      #ToDo: Should we make catalog and match supplier together or we should separate this two?
      Products::CatalogProcessingService.new(current_user, params).process_catalog
    rescue => e
      #ToDo: mailer(or notifier) to notify administrator
      @errors << I18n.t('excel_import.load_file_error')
      send_mail_to_current_user(counter)
    end

    private

    def open_spreadsheet
      Roo::Excelx.new(@file_path)
    end

    def load_imported_items
      binding.pry
      object_hash = []
      spreadsheets = open_spreadsheet
      spreadsheet = spreadsheets.sheet("Ark1")
      binding.pry
      #need to add get_sheet for different excells
      header = get_header_columns
      (obj_data[:starting_point]..spreadsheet.last_row).map do |i|
        binding.pry
        row = Hash[[header, spreadsheet.row(i)].transpose] if validations_by_type(spreadsheet, i)
        object_hash.push(row)
      end
      object_hash.compact
    end

    #def validations_by_type(spreadsheet, row)
    #  bank_account = is_tbc ? receiver_account_number(tbc_summary_spreadsheet, 5, 3) :
    #                     receiver_account_number(spreadsheet, row, obj_data[:receiver_account])
    #
    #  validation_passed = amount_validation(spreadsheet, row, obj_data[:amount_column]) && date_validation(spreadsheet, row, obj_data[:date_column]) &&
    #      document_number_validation(spreadsheet, row, obj_data[:document_number]) && bank_account
    #
    #  bog_validation_passed =  is_bog.eql?(true) ? bog_incomes_validation(spreadsheet, row, obj_data[:credit]) : true
    #
    #  validation_passed && bog_validation_passed
    #end
    #
    #def bog_incomes_validation(spreadsheet, row, column)
    #  unless spreadsheet.cell(row, column) != nil
    #    return false
    #  end
    #  true
    #end

    #def amount_validation(spreadsheet, row, column)
    #  unless spreadsheet.cell(row, column) != nil && spreadsheet.cell(row, column) != 0 && spreadsheet.celltype(row, column).eql?(:float) && spreadsheet.cell(row, column).positive?
    #    @errors << I18n.t('excel_import.amount_error', row: row)
    #    return false
    #  end
    #  true
    #end
    #
    #def date_validation(spreadsheet, row, column)
    #  unless spreadsheet.cell(row, column).is_a?(Date) && spreadsheet.celltype(row, column).eql?(:date)
    #    @errors << I18n.t('excel_import.date_error', row: row)
    #    return false
    #  end
    #  true
    #end
    #
    #def document_number_validation(spreadsheet, row, column)
    #  unless spreadsheet.cell(row, column) != nil && spreadsheet.cell(row, column) !~ /\D/
    #    @errors << I18n.t('excel_import.document_number_error', row: row)
    #    return false
    #  end
    #  true
    #end
    #
    #def receiver_account_number(spreadsheet, row, column)
    #  length = spreadsheet.cell(row, column).delete_prefix("GEL").delete_suffix("GEL").length if spreadsheet.celltype(row, column).eql?(:string)
    #  unless spreadsheet.cell(row, column) != nil && spreadsheet.celltype(row, column).eql?(:string) && length.eql?(22)
    #    @errors << I18n.t('excel_import.account_number_error', row: row)
    #    return false
    #  end
    #  true
    #end

    def obj_data
      file_type = "always24"
      #ToDo: this is some kind of options
      case file_type
      when "always24" then { starting_point: 3, date_column: 1, amount_column: 5, receiver_account: 9, document_number: 9 }
      when "file_type_2" then { starting_point: 14, date_column: 1, amount_column: 22, receiver_account: 17, document_number: 8, credit: 5 }
      when "file_type_3" then { starting_point: 2, date_column: 7, amount_column: 1, receiver_account: 6, document_number: 5}
      else raise "Unknown Bank type"
      end
    end

    def get_header_columns
      file_type = "always24"
      #Example: ":transaction_date, :prescription, :u_3, :u_4, :total_amount, :u_6, :u_7, :u_8, :transaction_code,
      #                       :u_10, :sender, :sender_identification_code, :u_12, :u_13, :u_14, :u_15, :u_16, :u_17, :u_18, :u_19, :u_20, :u_21"

                    #detect= ":Product_name, Product_no, Description, :Product_type, :Product_type_text, Product_group_ID
                    #       , :Product_group, Volume, Product_code, EAN_code, :Weight, :Width, :Height, :Depth, VAT_type"
      case file_type
      when "always24" then [":Product_no, :Product_code, :Product_name, :Description, :Product_type, :Product_type_text,
                             :Product_group_ID, :Product_group, :Vendor_ID, :Supplier_name, :Department_ID, :Department,
                             :List_price, :Purchase_price, :Manufacturing_cost, :Cost_price, :Delivery_time, :EAN_code,
                             :Other_supplier_code, :Subscription, :Commission_product, :VAT_type, :Weight, :Width,
                             :Height, :Depth, :Volume"]
      when "file_type_2" then ["sheet2 columns by example"]
      when "file_type_3" then ["sheet3 columns by example"]
      else raise "Unknown Bank type"
      end
    end

    def get_sheet
      case params["file_type"]
      when "Sheet1" then "Sheet name1"
      when "Sheet2" then "Sheet name2"
      when "Sheet3" then "Sheet name3"
      else raise "Unknown file name"
      end
    end
    #
    #def tbc_account
    #  { account_number: tbc_summary_spreadsheet.row(5)[2] }
    #end
    #
    #def tbc_summary_spreadsheet
    #  spreadsheets = open_spreadsheet
    #  spreadsheets.sheet("Summary")
    #end
    #
    #def is_tbc
    #  params["file_type"].eql?("TBC")
    #end
    #
    #def is_bog
    #  params["file_type"].eql?("BOG")
    #end

    def delete_file
      begin
        File.delete(@file_path)
      rescue Errno::ENOENT #No such file or directory error handling
      end
    end
    #
    #def send_mail_to_current_user(counter)
    #  UserMailer.send_notification_excel_import(@current_user, @errors, counter, @bank_type.name).deliver
    #end

  end
end