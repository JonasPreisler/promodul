require 'swagger_helper'

describe 'Clients', type: :request do

  path '/{locale}/orders' do
    post 'Create Order' do
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
              client_id:        { type: :integer },
              order_type_id:    { type: :integer },
              user_account_id:  { type: :integer }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   order: {
                       type: :object,
                       properties: {
                           id:         {type: :integer},
                           title:      {type: :string},
                           start_time: { type: :string},
                           order_type: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           order_status:    {
                               type: :object,
                               properties: {
                                   name: { type: :object }
                               }
                           },
                           client:    {
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

  path '/{locale}/orders/claim_order' do
    post 'Claim Order' do
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
              order_id:            { type: :integer },
              user_account_id:  { type: :integer }
          }
      }
      response '201', 'ok' do
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

  path '/{locale}/orders/order_type' do
    get 'Returns order types' do
      tags 'Order'
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


  path '/{locale}/orders/orders_list' do
    get 'Returns orders' do
      tags 'Order'
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
                               id:         {type: :integer},
                               title:      {type: :string},
                               start_time: { type: :string},
                               order_type: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string }
                                   }
                               },
                               order_status:    {
                                   type: :object,
                                   properties: {
                                       name: { type: :object }
                                   }
                               },
                               client:    {
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
               }
        run_test!
      end

    end
  end

  path '/{locale}/orders/my_orders_list/{id}' do
    get 'Returns my orders' do
      tags 'Order'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :id, in: :path, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   clients: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               title:      {type: :string},
                               start_time: { type: :string},
                               order_type: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string }
                                   }
                               },
                               order_status:    {
                                   type: :object,
                                   properties: {
                                       name: { type: :object }
                                   }
                               },
                               client:    {
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
               }
        run_test!
      end

    end
  end

  path '/{locale}/orders/open_orders_list' do
    get 'Returns my orders' do
      tags 'Order'
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
                   events: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               name:      {type: :string},
                               start: { type: :string},
                               end: { type: :string}
                           }
                       }
                   }
               }
        run_test!
      end

    end
  end

  path '/{locale}/orders/{id}' do
    get 'Returns order' do
      tags 'Order'
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
                           id:          { type: :integer },
                           title:       { type: :string },
                           description: { type: :string },
                           start_time:  { type: :string },
                           deadline:    { type: :string },
                           created_at:  { type: :string },
                           order_type: {
                               type: :object,
                               properties: {
                                   name: { type: :string }
                               }
                           },
                           order_status:    {
                               type: :object,
                               properties: {
                                   name: { type: :object }
                               }
                           },
                           client:    {
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

      response '404', 'not found' do
        run_test!
      end

    end
  end

  path '/{locale}/orders/overview/{id}' do
    get 'Returns orders overview' do
      tags 'Order'
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
                   overview: {
                       type: :object,
                       properties: {
                           percentage_of_tasks: {
                               type: :object,
                               properties: {
                                   open: { type: :integer },
                                   in_progress: { type: :integer },
                                   done: { type: :integer },
                                   total: { type: :integer }
                               }
                           },
                           worked_hours:    { type: :integer},
                           order_price:    { type: :number},
                           order_members:    {
                               type: :array,
                               items: {
                                   properties: {
                                       username: { type: :integer },
                                       email: { type: :string },
                                       phone_number: { type: :string }
                                   }
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

  path '/{locale}/orders/all_orders_list' do
    get 'Returns all orders' do
      tags 'Order'
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
                   events: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               name:      {type: :string},
                               start: { type: :string},
                               end: { type: :string}
                           }
                       }
                   }
               }
        run_test!
      end

    end
  end

end