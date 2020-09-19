class ProductsIndex < Chewy::Index
  require 'chewy_helper'

  settings analysis: {
      analyzer: {
          ngram_analyzer: {
              tokenizer: "ngram_tokenizer",
              filter: ["lowercase"]
          },
          edge_ngram_analyzer: {
              tokenizer: "edge_ngram_tokenizer",
              filter: ["lowercase"]
          }
      },
      tokenizer: {
          edge_ngram_tokenizer: {
              type: "edge_ngram",
              max_gram: 50
          },
          ngram_tokenizer: {
              type: "ngram",
              max_gram: 50
          }
      }
  }

  product_scope = Product
                         .select(:id, :name, :full_name)
                         .joins(:supplier_products, :product_images)
                         .includes(:supplier_characteristic)
                         .where('supplier_products.is_active = true')
                         .group('product.id')

  define_type product_scope do
    #ToDo: Here we should customize Elastic Fields by needed(especially  )
    field :id, type: 'integer'
    #field :price, type: 'float', value: -> (product) { ChewyHelper.get_min_price_data(product)&.price || 0 }
    #field :initial_price, type: 'float', value: -> (product) { ChewyHelper.get_min_price_data(product)&.initial_price || 0 }
    #field :system_discount, type: 'boolean', value: -> (product) { ChewyHelper.get_min_price_data(product)&.system_discount || false }
    #field :min_sell_amount, type: 'integer', value: -> (product) { ChewyHelper.get_min_sell_amount_for_provider(product) }
    #field :image_uuid, value: -> (product) { product.product_images.first&.uuid }
    field :product_image do
      field :uuid, type: 'string'
      field :name, type: 'string'
    end
    field :name_sort, type: 'object', value: -> (product) { ChewyHelper.products_name_object(product) }

    field :name, type: 'object', value: -> (product) { product.attributes['name'] } do
      I18n.available_locales.each do |locale|
        field locale.to_sym, analyzer: 'edge_ngram_analyzer'
      end
    end

    field :full_name, type: 'object', value: -> (product) { product.attributes['full_name'] } do
      I18n.available_locales.each do |locale|
        field locale.to_sym, analyzer: 'ngram_analyzer'
      end
    end

    field :product_characteristic, type: 'object' do
      field :shape
      field :packaging
      field :volume
      field :manufacturer
      field :description
      field :external_code
      field :sales_start, type: 'datetime'
      field :sales_end, type: 'datetime'
      field :sales_end, type: 'datetime'
      field :EAN_code
      field :weight
      field :width
      field :height
      field :depth
      field :need_recipe, type: 'boolean'
      field :product_type_id, type: 'integer'
      field :product_vat_type_id, type: 'integer'
      field :sub_category_id, type: 'integer'
      field :category_id, type: 'integer', value: -> (characteristic) { characteristic.sub_category&.category_id }

      field :generic, type: 'object', value: -> (characteristic) { characteristic.attributes['generic'] } do
        I18n.available_locales.each do |locale|
          field locale.to_sym, analyzer: 'ngram_analyzer'
        end
      end
    end

  end
end
