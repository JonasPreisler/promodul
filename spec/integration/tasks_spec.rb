require 'swagger_helper'

describe 'Orders', type: :request do

  path '/{locale}/tasks' do
    post 'Create Order task' do
      tags 'Order'
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
              title:            { type: :string },
              description:      { type: :string },
              start_time:       { type: :string },
              deadline:         { type: :string },
              order_id:         { type: :integer },
              product_id:         { type: :integer },
              user_account_id:  { type: :integer }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   task: {
                       type: :object,
                       properties: {
                           id:         {type: :integer},
                           title:      {type: :string},
                           start_time: { type: :string},
                           deadline:   { type: :string},
                           task_status:    {
                               type: :object,
                               properties: {
                                   name: { type: :object }
                               }
                           },
                           user_account:    {
                               type: :object,
                               properties: {
                                   username: { type: :object }
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

  #path '/{locale}/orders/order_type' do
  #  get 'Returns order types' do
  #    tags 'Order'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'Client token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 types: {
  #                     type: :object,
  #                     properties: {
  #                         id:      { type: :integer },
  #                         name:    { type: :string },
  #                         id_name: { type: :string }
  #                     }
  #                 }
  #             }
  #
  #      run_test!
  #    end
  #
  #  end
  #end
  #
  #
  #path '/{locale}/orders/orders_list' do
  #  get 'Returns orders' do
  #    tags 'Order'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'Client token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 clients: {
  #                     type: :array,
  #                     items: {
  #                         properties: {
  #                             id:         {type: :integer},
  #                             title:      {type: :string},
  #                             start_time: { type: :string},
  #                             order_type: {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :string }
  #                                 }
  #                             },
  #                             order_status:    {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :object }
  #                                 }
  #                             },
  #                             client:    {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :object }
  #                                 }
  #                             },
  #                             user_account:    {
  #                                 type: :object,
  #                                 properties: {
  #                                     username: { type: :object }
  #                                 }
  #                             }
  #                         }
  #                     }
  #                 }
  #             }
  #      run_test!
  #    end
  #
  #  end
  #end
  #
  #path '/{locale}/orders/{id}' do
  #  get 'Returns order' do
  #    tags 'Order'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'JWT token'
  #              })
  #
  #    parameter name: :id, in: :path, type: :integer, required: true
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #
  #    response '201', 'ok' do
  #      schema type: :object,
  #             properties: {
  #                 client: {
  #                     type: :object,
  #                     properties: {
  #                         id:          { type: :integer },
  #                         title:       { type: :string },
  #                         description: { type: :string },
  #                         start_time:  { type: :string },
  #                         deadline:    { type: :string },
  #                         created_at:  { type: :string },
  #                         order_type: {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :string }
  #                             }
  #                         },
  #                         order_status:    {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :object }
  #                             }
  #                         },
  #                         client:    {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :object }
  #                             }
  #                         },
  #                         user_account:    {
  #                             type: :object,
  #                             properties: {
  #                                 username: { type: :object }
  #                             }
  #                         }
  #                     }
  #                 }
  #             }
  #
  #      run_test!
  #    end
  #
  #    response '404', 'not found' do
  #      run_test!
  #    end
  #
  #  end
  #end

  #path '/{locale}/clients' do
  #  put 'Update client' do
  #    tags 'Client'
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
  #            id:           {type: :integer},
  #            name:             { type: :string },
  #            address:          { type: :string },
  #            vat_number:       { type: :string },
  #            phone:            { type: :string },
  #            web_address:      { type: :string },
  #            kunde_nr:         { type: :string },
  #            country_id:       { type: :integer },
  #            city_id:          { type: :integer },
  #            user_account_id:  { type: :integer },
  #            clients_group_id: { type: :integer },
  #            clients_type_id:  { type: :integer },
  #            currency_id:      { type: :integer },
  #        }
  #    }
  #    response '201', 'ok' do
  #      schema type: :object,
  #             properties: {
  #                 client: {
  #                     type: :object,
  #                     properties: {
  #                         id:    { type: :integer  },
  #                         name:  { type: :string },
  #                         clients_group: {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :string }
  #                             }
  #                         },
  #                         clients_type:    {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :object }
  #                             }
  #                         }
  #                     }
  #                 }
  #             }
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
  #
  #path '/{locale}/clients' do
  #  delete 'Delete client' do
  #    tags 'Client'
  #    consumes 'multipart/form-data'
  #
  #    parameter({
  #                  in: :header,
  #                  type: :string,
  #                  name: :Authorization,
  #                  required: true,
  #                  description: 'JWT token'
  #              })
  #
  #    parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
  #    parameter name: :id,     in: :query,  type: :integer,  required: true
  #
  #    response '204', 'OK' do
  #
  #      schema type: :object,
  #             properties: {
  #                 success: { type: :boolean }
  #             }
  #
  #      run_test!
  #    end
  #
  #    response '404', 'Not Found' do
  #
  #      run_test!
  #    end
  #  end
  #end

end