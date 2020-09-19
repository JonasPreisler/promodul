require 'swagger_helper'

describe 'ProductType ', type: :request do
  path '/{locale}/product_types' do
    post 'Create product type' do
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
              name:      {
                  type: :object,
                  properties: {
                      no: {type: :string},
                      en: {type: :string}
                  }
              },
              active:    {type: :boolean}
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   category: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string},
                           active: {type: :boolean}
                       }
                   }
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end

    end
  end

  path '/{locale}/product_types' do
    put 'Update product type' do
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
              name:      {
                  type: :object,
                  properties: {
                      no: {type: :string},
                      en: {type: :string}
                  }
              },
              id_name:          {type: :string},
              active:    {type: :boolean}
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   product_type: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string},
                           active: {type: :boolean}
                       }
                   }
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end

    end
  end

  path '/{locale}/product_types' do
    delete 'delete product types' do
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

  path '/{locale}/product_types/product_type_list' do
    get 'Returns product types list' do
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
                   product_types: {
                       type: :array,
                       items: {
                           properties: {
                               name: {type: :string},
                               id_name: {type: :string},
                               active: { type: :boolean}
                           }

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

end


