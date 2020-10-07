require 'swagger_helper'

describe 'ProductType ', type: :request do
  path '/{locale}/settings/country' do
    post 'Add country into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :string },
              country_code: { type: :string }
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
                           country_code: {type: :string}
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

  path '/{locale}/settings/city' do
    post 'Add city into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              country_id: { type: :integer },
              name:      { type: :string },
              city_code: { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   product_type: {
                       type: :object,
                       properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           city_code: { type: :string },
                           country_id:   { type: :integer }
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

  path '/{locale}/settings/countries' do
    get 'Returns countries' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      response '200', 'OK' do
        schema type: :object,
               properties: {
                   product_types: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               country_code: { type: :string }
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

  path '/{locale}/settings/cities' do
    get 'Returns cities' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :country_id,     in: :query,  type: :integer,  required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   product_types: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               city_code: { type: :string },
                               country_id: { type: :integer }
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


