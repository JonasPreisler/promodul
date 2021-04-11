require 'swagger_helper'

describe 'Orders', type: :request do

  path '/{locale}/tasks' do
    post 'Create project task' do
      tags 'Projects'
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
              project_id:         { type: :integer },
              user_account_tasks_attributes: {
                  type: :array,
                  items: {
                      properties: {
                          user_account_id:     { type: :integer }
                      }
                  }
              },
              task_resources_attributes: {
                  type: :array,
                  items: {
                      properties: {
                          resource_id:     { type: :integer }
                      }
                  }
              }
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

  path '/{locale}/tasks/tasks_list/{project_id}' do
    get 'Returns project tasks' do
      tags 'Projects'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :project_id, in: :path, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   tasks: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               title:      {type: :string},
                               start_time: { type: :string},
                               deadline:   { type: :string},
                               status:     { type: :string},
                               project_name: { type: :string},
                               users:    {
                                   type: :array,
                                   items: {
                                       properties: {
                                           first_name: { type: :object },
                                           last_name_name: { type: :object }
                                       }
                                   }

                               },
                               resources:    {
                                   type: :array,
                                   items: {
                                       properties: {
                                           name: { type: :object }
                                       }
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

  path '/{locale}/tasks/status_progress/{id}' do
    get 'Returns task progress' do
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
      parameter name: :id_name, in: :query, type: :string, required: true

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

    end
  end


  path '/{locale}/tasks/{id}' do
    get 'Returns task' do
      tags 'Projects'
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
                   task: {
                       type: :object,
                       properties: {
                           id:         {type: :integer},
                           title:      {type: :string},
                           start_time: { type: :string},
                           deadline:   { type: :string},
                           status:     { type: :string},
                           project_name: { type: :string},
                           users:    {
                               type: :array,
                               items: {
                                   properties: {
                                       first_name: { type: :object },
                                       last_name_name: { type: :object }
                                   }
                               }

                           },
                           resources:    {
                               type: :array,
                               items: {
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

      response '404', 'not found' do
        run_test!
      end

    end
  end

  path '/{locale}/tasks' do
    put 'Update task' do
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
              id:           {type: :integer},
              title:            { type: :string },
              description:      { type: :string },
              start_time:       { type: :string },
              deadline:         { type: :string },
              tracked_time:   { type: :string},
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
                           description:      {type: :string},
                           start_time: { type: :string},
                           deadline:   { type: :string},
                           tracked_time:   { type: :string},
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
                           },
                           product: {
                               type: :object,
                               properties: {
                                   name: { type: :integer }
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

  path '/{locale}/tasks' do
    delete 'Delete task' do
      tags 'Order'
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