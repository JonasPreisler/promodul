require 'swagger_helper'

describe 'Users ', type: :request do
  #path '/{locale}/users/approve_registration' do
  #  post 'Approve user registration' do
  #    tags 'Users'
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
  #    parameter name: :id,     in: :query, type: :integer, required: true
  #    parameter name: :role_group_id,     in: :query, type: :integer, required: true
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #
  #    response '200', 'OK' do
  #
  #      schema type: :object,
  #             properties: {
  #                 success: { type: :boolean }
  #             }
  #      run_test!
  #    end
  #
  #    response '400', 'Bad request' do
  #      {}
  #
  #      run_test!
  #    end
  #  end
  #end

  path '/{locale}/users/user_calendar/{id}' do
    get 'Returns calendar dates' do
      tags 'Users'
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

  path '/{locale}/users/employee_calendar' do
    get 'Returns employee dates' do
      tags 'Users'
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
                   dates: {
                       type: :array,
                       items: {
                           properties: {
                               id:            { type: :integer },
                               title:          { type: :string },
                               contact:        { type: :boolean },
                               address:  { type: :string },
                               start:      { type: :string  },
                               end:         { type: :string },
                               assign_id: { type: :integer },
                               assign_type:  { type: :integer },
                               status:     { type: :string }
                           }
                       }
                   }
               }

        run_test!
      end

    end
  end

  path '/{locale}/users/list' do
    get 'Get Users list' do
      tags 'Users'
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

      response '200', 'OK' do

        schema type: :object,
               properties: {
                   users: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               id:            { type: :integer },
                               name:          { type: :string },
                               active:        { type: :boolean },
                               phone_number:  { type: :string },
                               username:      { type: :string  },
                               email:         { type: :string },
                               role_group_id: { type: :integer },
                               user_role_id:  { type: :integer },
                               role_name:     { type: :string }
                           }
                       }
                   }
               }
        run_test!
      end

      response '400', 'Bad request' do
        {}

        run_test!
      end
    end
  end

  path '/{locale}/users/task_user_list' do
    get 'Get Task Users list' do
      tags 'Users'
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
      parameter name: :start_date, in: :query, type: :string, required: true
      parameter name: :deadline, in: :query, type: :string, required: true

      response '200', 'OK' do

        schema type: :object,
               properties: {
                   employees: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               id:            { type: :integer },
                               name:          { type: :string },
                               active:        { type: :boolean },
                               phone_number:  { type: :string },
                               username:      { type: :string  },
                               email:         { type: :string },
                               role_group_id: { type: :integer },
                               user_role_id:  { type: :integer },
                               role_name:     { type: :string },
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

      response '400', 'Bad request' do
        {}

        run_test!
      end
    end
  end

  path '/{locale}/users/delete_user/{id}' do
    post 'Delete user' do
      tags 'Users'
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
                   success: { type: :boolean }
               }

        run_test!
      end

    end
  end


  path '/{locale}/users/current_user' do
    get 'Get current user' do
      tags 'Users'
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

      response '200', 'OK' do

        schema type: :object,
               properties: {
                   current_user: {
                       type: :object,
                       properties: {
                           phone_number: { type: :string },
                           email: { type: :string },
                           username: { type: :string },
                           user_role: {
                               type: :object,
                               properties: {
                                   id: { type: :integer },
                                   role_group: {
                                       type: :object,
                                       properties: {
                                           name: { type: :string },
                                           product_group_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           },
                                           product_type_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           },
                                           product_import_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   import: { type: :boolean }
                                               }
                                           },
                                           product_catalog_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   set_price_data: { type: :boolean }
                                               }
                                           },
                                           suppliers_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           },
                                           system_data_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           },
                                           company_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           },
                                           role_management_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   create_data: { type: :boolean },
                                                   edit_data: { type: :boolean },
                                                   delete_record: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           },
                                           user_management_permission: {
                                               type: :object,
                                               properties: {
                                                   no_access: { type: :boolean },
                                                   read_data: { type: :boolean },
                                                   manage_data: { type: :boolean },
                                                   activate_data: { type: :boolean }
                                               }
                                           }
                                       }
                                   }
                               }
                           }
                       }
                   }
               }
        run_test!
      end

      response '400', 'Bad request' do
        {}

        run_test!
      end
    end
  end

  #path '/{locale}/users/listen_to_unconfirmed_users' do
  #  get 'Listening to unconfirmed users' do
  #    tags 'Users'
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
  #
  #    response '200', 'OK' do
  #
  #      schema type: :object,
  #             properties: {
  #                 pending: { type: :integer }
  #             }
  #      run_test!
  #    end
  #
  #    response '400', 'Bad request' do
  #      {}
  #
  #      run_test!
  #    end
  #  end
  #end
end


