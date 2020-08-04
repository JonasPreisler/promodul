require 'swagger_helper'

describe 'SubCategory', type: :request do

  path '/{locale}/terms_and_conditions' do
    post 'Create terms and conditions' do
      tags 'Basic info'
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
              active_from: {type: :string},
              version: {type: :string},
              description: {type: :string},
              terms_end_conditions: {type: :string}
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   terms_and_conditions: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           active_from: {type: :string},
                           version: {type: :string},
                           description: {type: :string},
                           terms_end_conditions: {type: :string}
                       }
                   }
               }

        run_test!
      end

      response '404', 'Not Found' do

        #let(:id) { 0 }
        #let(:picture) { @picture }

        run_test!
      end

    end
  end

  path '/{locale}/terms_and_conditions/list' do
    get 'Returns active terms and conditions' do
      tags 'Basic info'
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
                   terms_and_conditions: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               active_from: {type: :string},
                               version: {type: :string},
                               description: {type: :string},
                               terms_end_conditions: {type: :string}
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