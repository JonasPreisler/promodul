require 'swagger_helper'

describe 'SubCategory', type: :request do

  path '/{locale}/companies' do
    post 'Create company' do
      tags 'Company'
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
              name:         { type: :string },
              description:  { type: :string },
              address:      { type: :string },
              phone_number: { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   company: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           description:  { type: :string },
                           address:      { type: :string },
                           phone_number: { type: :string }
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

  path '/{locale}/companies' do
    put 'Update company' do
      tags 'Company'
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
              name:         { type: :string },
              description:  { type: :string },
              address:      { type: :string },
              phone_number: { type: :string },
              country_id: { type: :integer },
              city_id:    { type: :integer },
              parent_id:    { type: :integer }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   company: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           description:  { type: :string },
                           address:      { type: :string },
                           phone_number: { type: :string },
                           parent_id:    { type: :integer },
                           country: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           city:    {
                               type: :object,
                               properties: {
                                   name: { type: :object }
                               }
                           }
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

  path '/{locale}/companies/company_list' do
    get 'Returns companies' do
      tags 'Company'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      #parameter name: :category_id, in: :query, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   companies: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               address:      { type: :string },
                               phone_number: { type: :string },
                               parent_id:    { type: :integer },
                               country: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string }
                                   }
                               },
                               city:    {
                                   type: :object,
                                   properties: {
                                       name: { type: :object }
                                   }
                               }
                           }
                       }
                   }
               }

        run_test!
      end

    end
  end

  path '/{locale}/companies' do
    delete 'delete company' do
      tags 'Company'
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
                   success: { type: :boolean }
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/companies/sub_company_list' do
    get 'Returns sub companies' do
      tags 'Company'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :parent_id, in: :query, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   companies: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               address:      { type: :string },
                               phone_number: { type: :string },
                               parent_id:    { type: :integer },
                               country: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string }
                                   }
                               },
                               city:    {
                                   type: :object,
                                   properties: {
                                       name: { type: :object }
                                   }
                               }
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

  path '/{locale}/companies/{company_id}' do
    get 'Returns company' do
      tags 'Company'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'JWT token'
                })

      parameter name: :company_id, in: :path, type: :integer, required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"

      response '201', 'ok' do
        schema type: :object,
               properties: {
                   company: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           description:  { type: :string },
                           address:      { type: :string },
                           phone_number: { type: :string },
                           parent_id:    { type: :integer },
                           company_logo: {
                               type: :object,
                               properties: {
                                   uuid: { type: :string }
                               }
                           },
                           country: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           city:    {
                               type: :object,
                               properties: {
                                   name: { type: :object }
                               }
                           }
                       }
                   }
               }

        run_test!
      end

      response '404', 'not found' do
        run_test!
      end

    end
  end

end