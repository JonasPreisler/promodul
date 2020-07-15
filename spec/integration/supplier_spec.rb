require 'swagger_helper'

describe 'Supplier ', type: :request do
  path '/{locale}/supplier' do
    post 'Supplier registration' do
      tags 'Supplier'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name: {type: :string},
              phone_number: {type: :string},
              integration_system_id: {type: :integer},
              business_type_id: {type: :integer},
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
                           identification_code: {type: :string}
                       }}
               }

        end

        run_test!
      end

      response '400', 'Bad request' do
        {}

        run_test!
      end
  end
end


