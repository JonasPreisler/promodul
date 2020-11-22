require 'swagger_helper'

describe 'Clients', type: :request do

  path '/{locale}/clients' do
    post 'Create client' do
      tags 'Client'
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
              name:             { type: :string },
              address:          { type: :string },
              vat_number:       { type: :string },
              phone:            { type: :string },
              web_address:      { type: :string },
              kunde_nr:         { type: :string },
              country_id:       { type: :integer },
              city_id:          { type: :integer },
              user_account_id:  { type: :integer },
              clients_group_id: { type: :integer },
              clients_type_id:  { type: :integer },
              currency_id:      { type: :integer },

          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   client: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           clients_group: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           clients_type:    {
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

  path '/{locale}/clients/client_type' do
    get 'Returns client types' do
      tags 'Client'
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
                   types: {
                       type: :object,
                       properties: {
                           id:      { type: :integer },
                           name:    { type: :string },
                           id_name: { type: :string }
                       }
                   }
               }

        run_test!
      end

    end
  end

  path '/{locale}/clients/client_group' do
    get 'Returns client groups' do
      tags 'Client'
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
                   groups: {
                       type: :object,
                       properties: {
                           id:      { type: :integer },
                           name:    { type: :string },
                           id_name: { type: :string }
                       }
                   }
               }

        run_test!
      end

    end
  end


  path '/{locale}/clients/clients_list' do
    get 'Returns clients' do
      tags 'Client'
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
                   clients: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               clients_group: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string }
                                   }
                               },
                               clients_type:    {
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

  path '/{locale}/clients/{id}' do
    get 'Returns client' do
      tags 'Client'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'JWT token'
                })

      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"

      response '201', 'ok' do
        schema type: :object,
               properties: {
                   client: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           clients_group: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           clients_type:    {
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

  path '/{locale}/clients' do
    put 'Update client' do
      tags 'Client'
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
              id:           {type: :integer},
              name:             { type: :string },
              address:          { type: :string },
              vat_number:       { type: :string },
              phone:            { type: :string },
              web_address:      { type: :string },
              kunde_nr:         { type: :string },
              country_id:       { type: :integer },
              city_id:          { type: :integer },
              user_account_id:  { type: :integer },
              clients_group_id: { type: :integer },
              clients_type_id:  { type: :integer },
              currency_id:      { type: :integer },
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   client: {
                       type: :object,
                       properties: {
                           id:    { type: :integer  },
                           name:  { type: :string },
                           clients_group: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           clients_type:    {
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

  path '/{locale}/clients' do
    delete 'Delete client' do
      tags 'Client'
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

end