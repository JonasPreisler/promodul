require 'swagger_helper'

describe 'Resources', type: :request do

  path '/{locale}/resources' do
    post 'Create resource' do
      tags 'Resources'
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
              resource_type_id:      { type: :integer },
              model_on_type: { type: :string },
              model_on_id:   { type: :integer }
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

  path '/{locale}/resources/resource_list' do
    get 'Returns resources' do
      tags 'Resources'
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
                   machines: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               mod_name:      { type: :string }
                           }
                       }
                   },
                   tools: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               tool_name:      { type: :string }
                           }
                       }
                   },
                   external_resources: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               external_name:      { type: :string }
                           }
                       }
                   }
               }

        run_test!
      end

    end
  end

  path '/{locale}/resources/resource_type_list' do
    get 'Returns resource types' do
      tags 'Resources'
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
                   types: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               id_name: { type: :string }
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

  path '/{locale}/resources' do
    put 'update resource' do
      tags 'Resources'
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
              id: { type: :integer },
              name:         { type: :string },
              description:  { type: :string },
              resource_type_id:      { type: :integer },
              model_on_type: { type: :string },
              model_on_id:   { type: :integer }
          }
      }

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

  path '/{locale}/resources' do
    delete 'delete resource' do
      tags 'Resources'
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

  path '/{locale}/resources/resource_calendar/{id}' do
    get 'Returns resources' do
      tags 'Resources'
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
                   dates: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               title: {type: :string},
                               start:  { type: :string },
                               end:      { type: :string },
                               task_title: { type: :string}
                           }
                       }
                   }
               }

        run_test!
      end

    end
  end

  path '/{locale}/resources/task_resource_list' do
    get 'Returns task resources' do
      tags 'Resources'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :start_date, in: :query, type: :string, required: true
      parameter name: :deadline, in: :query, type: :string, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   machines: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               mod_name:      { type: :string },
                               available_dates: {
                                   type: :array,
                                   items: {
                                       type: :object,
                                       properties: {
                                           first: { type: :string },
                                           last: { type: :string },
                                       }
                                   }
                               }
                           }
                       }
                   },
                   tools: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               tool_name:      { type: :string },
                               available_dates: {
                                   type: :array,
                                   items: {
                                       type: :object,
                                       properties: {
                                           first: { type: :string },
                                           last: { type: :string },
                                       }
                                   }
                               }
                           }
                       }
                   },
                   external_resources: {
                       type: :array,
                       items: {
                           properties: {
                               id: {type: :integer},
                               name: {type: :string},
                               description:  { type: :string },
                               external_name:      { type: :string },
                               available_dates: {
                                   type: :array,
                                   items: {
                                       type: :object,
                                       properties: {
                                           first: { type: :string },
                                           last: { type: :string },
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

end