require 'swagger_helper'

describe 'Supplier ', type: :request do
  path '/{locale}/suppliers' do
    post 'Supplier registration' do
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
              name: {type: :string},
              phone_number: {type: :string},
              integration_system_id: {type: :integer},
              business_type_id: {type: :integer},
              identification_code: {type: :string}
          }
      }
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '200', 'OK' do

        schema type: :object,
               properties: {
                   supplier: {
                       type: :object,
                       properties: {
                           name: {type: :string},
                           phone_number: {type: :string},
                           active: {type: :boolean},
                           integration_system_id: {type: :integer},
                           business_type_id: {type: :integer},
                           identification_code: {type: :string},
                           integration_system: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
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

  path '/{locale}/users/list' do
    get 'Get Suppliers list' do
      tags 'Users'
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

      response '200', 'OK' do

        schema type: :object,
               properties: {
                   users: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               id:            { type: :integer },
                               name:          { type: :string },
                               active:        { type: :boolean },
                               phone_number:  { type: :string },
                               username:      { type: :string  },
                               email:         { type: :string },
                               role_group_id: { type: :integer },
                               user_role_id:  { type: :integer },
                               role_name:     { type: :string }
                           }
                       }
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
end


