module Products
  class ProductCreateService
    require 'errors_format'
    include ErrorsFormat

    attr_reader :errors


    def initialize(product_params)
      @product_params = product_params
      @errors = []
    end

    def create_product
      validate_type!
      validate_vat_type!
      validate_department!
      create_product_item
    end

    def json_view
      {
          product: @product.as_json(include: {
                                    product_characteristic: {
                                        except: [:product_id, :sub_category_id, :product_type_id, :product_vat_type_id],
                                        include: {
                                            sub_category:     { only: [:name, :id_name] },
                                            product_type:     { only: [:name, :id_name] },
                                            product_vat_type: { only: [:name, :id_name] }
                                        }
                                    }
          })
      }
    end


    private

    def validate_type!
      product_type = ProductType.find_by_id(@product_params[:product_characteristic_attributes][:product_type_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless product_type
    end

    def validate_vat_type!
      return if @errors.any?
      product_vat_type = ProductVatType.find_by_id(@product_params[:product_characteristic_attributes][:product_vat_type_id])
      fill_custom_errors(self, :base,:invalid, I18n.t("custom.errors.data_not_found")) unless product_vat_type
    end

    def validate_department!
      return if @errors.any?
      #I need department architecture here
    end

    def create_product_item
      return if @errors.any?
      @product = Product.new(@product_params)
      @product.save
      @errors << fill_errors(@product) if @product.errors.any?
    end

  end
end