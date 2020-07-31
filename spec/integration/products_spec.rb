require 'swagger_helper'

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

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name: { type: :object },
              full_name: {  type: :object },
              description: {  type: :string },
              code: { type: :string },
              product_characteristic_attributes: {
                  type: :object,
                  properties: {
                      sub_category_id: { type: :integer },
                      shape: { type: :string  },
                      volume: { type: :string },
                      packaging: {  type: :string },
                      manufacturer: { type: :string },
                      description: {  type: :string}
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
                       properties: {
                           name: {type: :string},
                           full_name: {type: :string},
                           description: {type: :string},
                           code: {type: :string},
                           product_characteristic: {
                               type: :object,
                               properties: {
                                   shape:         { type: :string },
                                   volume:        { type: :string },
                                   packaging:     { type: :string },
                                   manufacturer:  { type: :string },
                                   description:   { type: :string }
                               }
                           }
                       }}
               }
        run_test!
      end

      response '400', 'Bad request' do
        {}

        run_test!
      end
    end

  end

  #path '/{locale}/suppliers/list' do
  #  get 'Get Suppliers list' do
  #    tags 'Supplier'
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
  #
  #    response '200', 'OK' do
  #
  #      schema type: :object,
  #             properties: {
  #                 business_types: {
  #                     type: :object,
  #                     properties: {
  #                         id: {type: :integer},
  #                         name: {type: :string},
  #                         registration_date: {type: :string},
  #                         identification_code: {type: :string},
  #                         phone_number: {type: :string}
  #                     }}
  #             }
  #      run_test!
  #    end
  #
  #    response '400', 'Bad request' do
  #      {}
  #
  #      run_test!
  #    end
  #  end
  #
  #end

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
              id: {type: :integer},
              name: { type: :object },
              full_name: {  type: :object },
              description: {  type: :string },
              code: { type: :string },
              product_characteristic_attributes: {
                  type: :object,
                  properties: {
                      id: { type: :integer},
                      sub_category_id: { type: :integer },
                      shape: { type: :string  },
                      volume: { type: :string },
                      packaging: {  type: :string },
                      manufacturer: { type: :string },
                      description: {  type: :string}
                  }
              }
          }
      }
      response '201', 'Created' do
        schema type: :object,
               properties: {
                   product: {
                       type: :object,
                       properties: {
                           name: {type: :string},
                           full_name: {type: :string},
                           description: {type: :string},
                           code: {type: :string},
                           product_characteristic: {
                               type: :object,
                               properties: {
                                   shape:         { type: :string },
                                   volume:        { type: :string },
                                   packaging:     { type: :string },
                                   manufacturer:  { type: :string },
                                   description:   { type: :string }
                               }
                           }
                       }}
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
                   products: [{
                       type: :object,
                       properties: {
                           name: {type: :string},
                           full_name: {type: :string},
                           description: {type: :string},
                           code: {type: :string},
                           product_characteristic: {
                               type: :object,
                               properties: {
                                   shape:         { type: :string },
                                   volume:        { type: :string },
                                   packaging:     { type: :string },
                                   manufacturer:  { type: :string },
                                   description:   { type: :string }
                               }
                           }
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

end


