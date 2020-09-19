module Products
  class CatalogProcessingService
    attr_accessor :current_user, :params

    def initialize(current_user = nil, params = nil)
      @current_user = current_user
      @params = params
      @matched_data =  []
      @invoice_statuses = []
      @errors = []
    end

    def process_catalog
      Products::CatalogProcessingWorker.perform_async(params, current_user.id)
      #Xlsx::MatchTransactionsWithInvoices.new.perform(params, current_user.id)
    end

    #def call
    #  @transactions_for_check = get_transactions_for_check
    #  @bank_accounts = @transactions_for_check.map{ |tran| tran["account_number"] }.uniq
    #
    #  @transactions_for_check.each do |transaction|
    #    compare_with_invoice(transaction)
    #  end
    #
    #  @transactions_for_check.map!{ |x| x.merge(is_checked: true) }
    #  if prepeard_params["invoices"].present?
    #    ActiveRecord::Base.transaction do
    #      BankTransactionsService.new(@current_user, @transactions_for_check).update
    #      BankTransactions::InvoiceTransactionsService.new(@current_user, prepeard_params).bulk_create
    #    end
    #  end
    #end

    #def update_invoice_status
    #  @invoice_statuses.each do |invoice|
    #    Invoice.find(invoice["id"]).update_column(:invoice_status_id, invoice["status_id"])
    #  end
    #end
    #
    #def prepeard_params
    #  ActionController::Parameters.new({
    #                                       connection_type: "automatic",
    #                                       distribution_type: "from_insurance",
    #                                       invoices: @matched_data
    #                                   } )
    #end
    #
    #def compare_with_invoice(transaction)
    #  @transaction = transaction
    #  get_invoices_for_check.each do |invoice|
    #    if invoice["invoice_number"].count("A-Z") > 0 && @transaction["prescription"]&.include?(invoice["invoice_number"]) && @transaction["current_amount"] != 0 && !check_invoice_number(invoice)
    #      amount, need_review = get_amount(invoice)
    #      if amount.to_i > 0
    #        @matched_data << { transaction_id: @transaction["table_id"], parent_id: invoice["invoice_id"], parent_type: "Invoice", amount: amount, need_review: need_review }
    #      end
    #    end
    #  end
    #end
    #
    #def get_transactions_for_check
    #  BankTransaction.where(is_checked: false).select("id as table_id, prescription, account_number, current_amount").as_json(except: :id)
    #end
    #
    #def check_invoice_number(invoice)
    #  prescription_index  = @transaction["prescription"]&.index(invoice["invoice_number"])
    #  is_number?(@transaction["prescription"][(prescription_index + invoice["invoice_number"].length)])
    #end
    #
    #def is_number? string
    #  true if Float(string) rescue false
    #end
    #
    #def get_invoices_for_check
    #  Invoice
    #      .joins("LEFT JOIN invoice_recognition_acts on invoices.id = invoice_recognition_acts.invoice_id")
    #      .joins("LEFT JOIN invoices as changed_invoices on invoices.id = changed_invoices.parent_id AND changed_invoices.changed_invoice = 1")
    #      .joins("LEFT JOIN invoice_recognition_acts as changed_invoice_recognition_acts on changed_invoice_recognition_acts.invoice_id = changed_invoices.id")
    #      .joins("LEFT JOIN invoice_types  ON invoice_types.id = COALESCE(changed_invoices.invoice_type_id, invoices.invoice_type_id)")
    #      .joins("INNER JOIN business_unit_settings as bu_settings ON bu_settings.business_unit_id = invoices.business_unit_id")
    #      .joins("LEFT JOIN business_unit_bank_accounts AS accounts ON accounts.business_unit_setting_id = bu_settings.id")
    #      .where("invoice_types.id_name IN ('total', 'completed_works', 'individual', 'global_budget') AND invoices.changed_invoice = :changed AND accounts.account_number IN (:acc_number)
    #              AND invoices.mark_for_deletion = :mark",
    #             acc_number: @bank_accounts, mark: false, changed: false)
    #      .select("COALESCE(changed_invoices.number, invoices.number) AS invoice_number, COALESCE(changed_invoices.id, invoices.id) AS invoice_id,
    #               COALESCE(changed_invoice_recognition_acts.final_compensation_amount_with_penalty,
    #                        changed_invoices.amount, invoice_recognition_acts.final_compensation_amount_with_penalty, invoices.amount)
    #                      AS invoice_debt")
    #      .order("invoices.created_at ASC")
    #      .as_json(except: :id)
    #end
    #
    #def get_paid_amount(invoice)
    #  Invoice
    #      .joins("LEFT JOIN invoice_recognition_acts on invoices.id = invoice_recognition_acts.invoice_id")
    #      .joins("LEFT JOIN invoices as changed_invoices on invoices.id = changed_invoices.parent_id")
    #      .joins("LEFT JOIN invoice_recognition_acts as changed_invoice_recognition_acts on changed_invoice_recognition_acts.invoice_id = changed_invoices.id")
    #      .joins("OUTER APPLY (SELECT SUM(attached_bank_transactions.amount) as amount_sum, max(transaction_date) as max_date
    #                                    FROM attached_bank_transactions
    #                                    LEFT JOIN bank_transactions on attached_bank_transactions.transaction_id = bank_transactions.id
    #                                    WHERE (attached_bank_transactions.parent_id = invoices.id OR attached_bank_transactions.parent_id = invoices.parent_id)
    #                                    AND attached_bank_transactions.parent_type = 'Invoice' AND attached_bank_transactions.mark_for_deletion = 0)
    #                       transaction_values")
    #      .where_bind('invoices.id = :id AND invoices.mark_for_deletion = :mark AND (invoices.changed_invoice = 1 OR changed_invoices.id IS NULL)',
    #                  id: invoice["invoice_id"], mark: false)
    #      .select("transaction_values.amount_sum")
    #      .as_json()
    #end
    #
    #def get_amount(invoice)
    #  amount = 0
    #  status_id = 0
    #  invoice_amount = invoice["invoice_debt"].to_i - get_paid_amount(invoice).first["amount_sum"].to_i
    #  if invoice_amount > 0
    #    if @transaction["current_amount"] >= invoice_amount
    #      amount = invoice_amount
    #      need_review = false
    #      #status_id = InvoiceStatus.find_by(id_name: "complete_payment")&.id
    #      @transaction["current_amount"] = @transaction["current_amount"] - invoice_amount
    #    else
    #      amount = @transaction["current_amount"]
    #      need_review = true
    #      #status_id = InvoiceStatus.find_by(id_name: "incomplete_payment")&.id
    #      @transaction["current_amount"] = 0
    #    end
    #    @transactions_for_check.map{ |x| x["current_amount"] = @transaction["current_amount"] if x["table_id"].eql?(@transaction["table_id"]) }
    #    [amount, need_review]
    #  end
    #end

  end
end