require 'swagger_helper'

describe 'Projects ', type: :request do
  path '/{locale}/projects' do
    post 'Create project' do
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
              title:   { type: :string },
              description:   { type: :string },
              address:    { type: :string },
              post_number:    { type: :string },
              contact_person: { type: :string },
              start_date: { type: :string },
              deadline: { type: :string },
              contact_person: { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   category: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           title: {type: :string},
                           description: {type: :string},
                           post_number: {type: :boolean},
                           contact_person: {type: :boolean},
                           start_date: { type: :string },
                           deadline: { type: :string },
                           project_id: {type: :string},
                           user_account: {
                               type: :object,
                               properties: {
                                   first_name: { type: :string },
                                   last_name: { type: :string }
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

  path '/{locale}/projects/{id}' do
    get 'Returns project' do
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
                   project: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           title: {type: :string},
                           description: {type: :string},
                           post_number: {type: :boolean},
                           contact_person: {type: :boolean},
                           start_date: { type: :string },
                           deadline: { type: :string },
                           project_id: {type: :string},
                           user_account: {
                               type: :object,
                               properties: {
                                   first_name: { type: :string },
                                   last_name: { type: :string }
                               }
                           }
                       }
                   },
                   members: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           first_name: { type: :string },
                           last_name: { type: :string },
                           status: { type: :string }
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

  path '/{locale}/categories' do
    put 'Update category' do
      tags 'Category and Sub category'
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
              name:      {
                  type: :object,
                  properties: {
                      no: {type: :string},
                      en: {type: :string}
                  }
              },
              id_name:          {type: :string},
              active:    {type: :boolean}
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   category: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string},
                           active: {type: :boolean}
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

  path '/{locale}/categories' do
    delete 'delete category' do
      tags 'Category and Sub category'
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
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/projects/projects_list' do
    get 'Returns Project list' do
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

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   projects: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               title: {type: :string},
                               description: {type: :string},
                               post_number: {type: :boolean},
                               contact_person: {type: :boolean},
                               project_id: {type: :string},
                               user_account: {
                                   type: :object,
                                   properties: {
                                       first_name: { type: :string },
                                       last_name: { type: :string }
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

end


