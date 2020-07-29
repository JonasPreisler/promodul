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

  #path '/{locale}/supplier/{id}' do
  #  delete 'Delete Supplier' do
  #    tags 'Supplier'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  in: :header,
  #                  type: :string,
  #                  name: :Authorization,
  #                  required: true,
  #                  description: 'JWT token'
  #              })
  #
  #    parameter name: :locale,   in: :path, type: :string, required: true, default: "en"
  #    parameter name: :id, in: :path, type: :string, required: true
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 supplier: {
  #                     type: :object,
  #                     properties: {
  #                         id: {type: :integer},
  #                         active: {type: :boolean}
  #                     }}
  #             }
  #      run_test!
  #    end
  #
  #    response '400', 'Bad request' do
  #      run_test!
  #    end
  #
  #  end
  #end
  #
  #path '/{locale}/supplier/business_types' do
  #  get 'Get Business types' do
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
  #                         is_name: {type: :string}
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
  #
  #path '/{locale}/supplier/integration_systems' do
  #  get 'Get Integration Systems' do
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
  #                 integration_systems: {
  #                     type: :object,
  #                     properties: {
  #                         id: {type: :integer},
  #                         name: {type: :string},
  #                         is_name: {type: :string}
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
end


