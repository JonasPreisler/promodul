require 'swagger_helper'
require_relative '../helpers/integration_methods'

describe 'Product ', type: :request do
  path '/{locale}/products' do
    post 'Create Product' do
      tags 'Product'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      #parameter name: :image,  in: :formData, type: :file,   required: true
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :object },
              full_name:    { type: :object },
              description:  { type: :string },
              code:         { type: :string },
              instruction:  { type: :string },
              product_characteristic_attributes: {
                  type: :object,
                  properties: {
                      sub_category_id:     { type: :integer },
                      product_type_id:     { type: :integer },
                      product_vat_type_id: { type: :integer },
                      shape:               { type: :string },
                      volume:              { type: :string },
                      packaging:           { type: :string },
                      manufacturer:        { type: :string },
                      description:         { type: :string },
                      external_code:       { type: :string },
                      sales_start:         { type: :string },
                      sales_end:           { type: :string },
                      EAN_code:            { type: :string },
                      weight:              { type: :number },
                      height:              { type: :number },
                      width:               { type: :number },
                      depth:               { type: :number },
                      subscription:        { type: :boolean },
                      commission:          { type: :boolean }
                  }
              }
          }
      }
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '200', 'OK' do
        schema type: :object,
               properties: {
                   product: {
                       type: :object,
                       properties: product_schema
                   }
               }
        run_test!
      end

      response '400', 'Bad request' do
        {}

        run_test!
      end
    end

  end

  path '/{locale}/products' do
    put 'Update Product' do
      tags 'Product'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              id:           { type: :integer },
              name:         { type: :object },
              full_name:    { type: :object },
              description:  { type: :string },
              instruction:  { type: :string },
              code:         { type: :string },
              product_characteristic_attributes: {
                  type: :object,
                  properties: {
                      id:                  { type: :integer },
                      sub_category_id:     { type: :integer },
                      product_type_id:     { type: :integer },
                      product_vat_type_id: { type: :integer },
                      shape:               { type: :string },
                      volume:              { type: :string },
                      packaging:           { type: :string },
                      manufacturer:        { type: :string },
                      description:         { type: :string },
                      external_code:       { type: :string },
                      sales_start:         { type: :string },
                      sales_end:           { type: :string },
                      EAN_code:            { type: :string },
                      weight:              { type: :number },
                      height:              { type: :number },
                      width:               { type: :number },
                      depth:               { type: :number },
                      subscription:        { type: :boolean },
                      commission:          { type: :boolean }
                  }
              }
          }
      }
      response '201', 'Updated' do
        schema type: :object,
               properties: {
                   product: {
                       type: :object,
                       properties: product_schema
                   }
               }
        run_test!
      end

      response '400', 'Bad Request' do
        {}

        run_test!
      end

    end
  end

  path '/{locale}/products/edit_product' do
    get 'Edit Product' do
      tags 'Product'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :id,     in: :query, type: :integer, required: true
      #parameter name: :params, in: :body, schema: {
      #    type: :object,
      #    properties: {
      #        id:           { type: :integer },
      #        name:         { type: :object },
      #        full_name:    { type: :object },
      #        description:  { type: :string },
      #        instruction:  { type: :string },
      #        code:         { type: :string },
      #        product_characteristic_attributes: {
      #            type: :object,
      #            properties: {
      #                id:                  { type: :integer },
      #                sub_category_id:     { type: :integer },
      #                product_type_id:     { type: :integer },
      #                product_vat_type_id: { type: :integer },
      #                shape:               { type: :string },
      #                volume:              { type: :string },
      #                packaging:           { type: :string },
      #                manufacturer:        { type: :string },
      #                description:         { type: :string },
      #                external_code:       { type: :string },
      #                sales_start:         { type: :string },
      #                sales_end:           { type: :string },
      #                EAN_code:            { type: :string },
      #                weight:              { type: :number },
      #                height:              { type: :number },
      #                width:               { type: :number },
      #                depth:               { type: :number },
      #                subscription:        { type: :boolean },
      #                commission:          { type: :boolean }
      #            }
      #        }
      #    }
      #}
      response '201', 'Updated' do
        schema type: :object,
               properties: {
                   product: {
                       type: :object,
                       properties: product_schema
                   }
               }
        run_test!
      end

      response '400', 'Bad Request' do
        {}

        run_test!
      end

    end
  end

  path '/{locale}/products' do
    delete 'Destroy product' do
      tags 'Product'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :id,     in: :query,  type: :integer,  required: true

      response '204', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/products/list' do
    get 'Returns products list' do
      tags 'Product'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   products: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: product_schema
                       }
                   }
               }
        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end
    end
  end

  path '/{locale}/products/product_vat_type' do
    get 'Returns product vat types' do
      tags 'Product'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   product_vat_types: [{
                                       type: :object,
                                       properties: {
                                           id:      { type: :string },
                                           name:    { type: :string },
                                           id_name: { type: :string }
                                       }}]
               }
        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end
    end
  end

  path '/{locale}/products/import_products' do
    post 'ImportProduct' do
      tags 'Product'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :excel,  in: :formData, type: :file,   required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '201', 'Created' do
        {}
        run_test!
      end

      response '400', 'Bad request' do
        run_test!
      end

    end
  end

end


