require 'swagger_helper'

describe 'Clients', type: :request do

  path '/{locale}/client_contacts' do
    post 'Create client contact' do
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
              first_name:  { type: :string },
              last_name:   { type: :string },
              email:       { type: :string },
              phone:       { type: :string },
              position:    { type: :string },
              client_id:   { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   contact: {
                       type: :object,
                       properties: {
                           id:          { type: :integer  },
                           first_name:  { type: :string },
                           last_name:   { type: :string },
                           email:       { type: :string },
                           phone:       { type: :string },
                           position:    { type: :string },
                           created_at:  { type: :string }
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

  path '/{locale}/client_contacts/contacts_list' do
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
      parameter name: :client_id, in: :query, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   contacts: {
                       type: :array,
                       items: {
                           properties: {
                               id:          { type: :integer  },
                               first_name:  { type: :string },
                               last_name:   { type: :string },
                               email:       { type: :string },
                               phone:       { type: :string },
                               position:    { type: :string },
                               created_at:  { type: :string }
                           }
                       }
                   }
               }

        run_test!
      end

    end
  end


  path '/{locale}/client_contacts' do
      put 'Update client contact' do
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
                id:               {type: :integer},
                first_name:  { type: :string },
                last_name:   { type: :string },
                email:       { type: :string },
                phone:       { type: :string },
                position:    { type: :string },
                client_id:   { type: :string }
            }
        }
        response '201', 'ok' do
          schema type: :object,
                 properties: {
                     contact: {
                         type: :object,
                         properties: {
                             id:          { type: :integer  },
                             first_name:  { type: :string },
                             last_name:   { type: :string },
                             email:       { type: :string },
                             phone:       { type: :string },
                             position:    { type: :string },
                             created_at:  { type: :string }
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

  path '/{locale}/client_contacts/{id}' do
    get 'Returns client contact' do
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
                   contact: {
                       type: :object,
                       properties: {
                           id:          { type: :integer  },
                           first_name:  { type: :string },
                           last_name:   { type: :string },
                           email:       { type: :string },
                           phone:       { type: :string },
                           position:    { type: :string },
                           created_at:  { type: :string }
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

  path '/{locale}/client_contacts' do
    delete 'Delete client contact' do
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