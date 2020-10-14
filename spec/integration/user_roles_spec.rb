require 'swagger_helper'

describe 'SubCategory', type: :request do

  path '/{locale}/user_roles' do
    post 'Create User Role' do
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
      parameter name: :user_account_id,     in: :query,  type: :integer,  required: true
      parameter name: :role_group_id,     in: :query,  type: :integer,  required: true

      response '201', 'ok' do
        schema type: :object,
               properties: {
                   user_role: {
                       type: :object,
                       properties: {
                           success: { type: :boolean }
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

  path '/{locale}/user_roles' do
    delete 'delete user role' do
      tags 'Users'
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