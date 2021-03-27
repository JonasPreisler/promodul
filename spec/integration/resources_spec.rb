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

  path '/{locale}/departments/department_list' do
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
      parameter name: :company_id, in: :query, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   departments: {
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

  path '/{locale}/departments' do
    delete 'delete department' do
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

  path '/{locale}/departments/sub_department_list' do
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
                   sub_departments: {
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

end