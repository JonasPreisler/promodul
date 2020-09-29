require 'swagger_helper'
require_relative '../helpers/integration_methods'

describe 'SupplierProduct ', type: :request do
  path '/{locale}/supplier_products' do
    post 'Create Supplier Product' do
      tags 'Supplier'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              supplier_id:    { type: :integer },
              product_id:     { type: :integer },
              supplier_code:  { type: :string },
              quantity:       { type: :integer },
              supplier_product_price_attributes: {
                  type: :object,
                  properties: {
                      price:        { type: :number },
                      currency_id:  { type: :integer }
                  }
              }
          }
      }
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '200', 'OK' do
        schema type: :object,
               properties: {
                   success: { type: :boolean }
               }
        run_test!
      end

      response '400', 'Bad request' do
        {}

        run_test!
      end
    end

  end

  path '/{locale}/supplier_products' do
    put 'Update Supplier Product' do
      tags 'Supplier'
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
              id:             { type: :integer },
              supplier_id:    { type: :integer },
              product_id:     { type: :integer },
              currency_id:    { type: :integer },
              is_active:      { type: :boolean },
              supplier_code:  { type: :string },
              quantity:       { type: :integer },
              supplier_product_price_attributes: {
                  type: :object,
                  properties: {
                      id:           { type: :integer },
                      price:        { type: :number },
                      currency_id:  { type: :integer }
                  }
              }
          }
      }
      response '201', 'Updated' do
        schema type: :object,
               properties: {
                   supplier_product: {
                       type: :object,
                       properties: {
                           id:            { type: :integer },
                           supplier_id:   { type: :integer },
                           product_id:    { type: :integer },
                           currency_id:   { type: :integer},
                           supplier_code: { type: :string },
                           is_active:     { type: :boolean },
                           quantity:      { type: :integer },
                           product: {
                               type: :object,
                               properties: {
                                   name:        { type: :string },
                                   description: { type: :string },
                                   instruction: { type: :string }
                               }
                           },
                           supplier_product_price: {
                               type: :object,
                               properties: {
                                   id:                  { type: :integer},
                                   supplier_product_id: { type: :integer },
                                   price:               { type: :number },
                                   currency_id:         { type: :integer},
                                   currency: {
                                       type: :object,
                                       properties: {
                                           name:    { type: :string },
                                           code:    { type: :string },
                                           symbol:  { type: :string}
                                       }
                                   }
                               }
                           }
                       }
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

  #path '/{locale}/products/edit_product' do
  #  get 'Edit Product' do
  #    tags 'Product'
  #    consumes 'application/json'
  #    produces 'application/json'
  #
  #    parameter({
  #                  in: :header,
  #                  type: :string,
  #                  name: :Authorization,
  #                  required: true,
  #                  description: 'JWT token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #    parameter name: :id,     in: :query, type: :integer, required: true
  #
  #    response '201', 'Updated' do
  #      schema type: :object,
  #             properties: {
  #                 product: {
  #                     type: :object,
  #                     properties: product_schema
  #                 }
  #             }
  #      run_test!
  #    end
  #
  #    response '400', 'Bad Request' do
  #      {}
  #
  #      run_test!
  #    end
  #
  #  end
  #end
  #
  path '/{locale}/supplier_products' do
    delete 'Deactivate supplier product' do
      tags 'Supplier'
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

  #path '/{locale}/products/list' do
  #  get 'Returns products list' do
  #    tags 'Product'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'Client token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 products: {
  #                     type: :array,
  #                     items: {
  #                         type: :object,
  #                         properties: product_schema
  #                     }
  #                 }
  #             }
  #      run_test!
  #    end
  #
  #    response '404', 'Not found' do
  #      schema type: :object,
  #             properties: {}
  #      run_test!
  #    end
  #  end
  #end
  #
  #path '/{locale}/products/product_vat_type' do
  #  get 'Returns product vat types' do
  #    tags 'Product'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'Client token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 product_vat_types: [{
  #                                         type: :object,
  #                                         properties: {
  #                                             id:      { type: :string },
  #                                             name:    { type: :string },
  #                                             id_name: { type: :string }
  #                                         }}]
  #             }
  #      run_test!
  #    end
  #
  #    response '404', 'Not found' do
  #      schema type: :object,
  #             properties: {}
  #      run_test!
  #    end
  #  end
  #end
  #
  #path '/{locale}/products/import_products' do
  #  post 'ImportProduct' do
  #    tags 'Product'
  #    consumes 'multipart/form-data'
  #
  #    parameter({
  #                  in: :header,
  #                  type: :string,
  #                  name: :Authorization,
  #                  required: true,
  #                  description: 'JWT token'
  #              })
  #
  #    parameter name: :excel,  in: :formData, type: :file,   required: true
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #    response '201', 'Created' do
  #      {}
  #      run_test!
  #    end
  #
  #    response '400', 'Bad request' do
  #      run_test!
  #    end
  #
  #  end
  #end

end


