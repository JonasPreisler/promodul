require 'swagger_helper'

describe 'Email', type: :request do

  #path '/{locale}/owner_infos' do
  #  post 'Send email' do
  #    tags 'Email'
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
  #    parameter name: :params, in: :body, schema: {
  #        type: :object,
  #        properties: {
  #            email:         { type: :string },
  #            phone:  { type: :string }
  #        }
  #    }
  #
  #    response '201', 'OK' do
  #
  #      schema type: :object,
  #             properties: {
  #                 success: { type: :boolean }
  #             }
  #
  #
  #      run_test!
  #    end
  #
  #    response '404', 'Not Found' do
  #
  #      run_test!
  #    end
  #
  #  end
  #end

end