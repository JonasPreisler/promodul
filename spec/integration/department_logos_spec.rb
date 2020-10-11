require 'swagger_helper'
require_relative  '../helpers/integration_methods'

describe 'DepartmentLogo', type: :request do

  path '/{locale}/department_logos' do
    post 'Create logo of department' do
      tags 'Company'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :logo,  in: :formData, type: :file,   required: true
      parameter name: :department_id,     in: :formData, type: :integer, required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"

      response '201', 'Created' do
        run_test!
      end

      response '400', 'Bad request' do
        run_test!
      end

    end
  end

  path '/{locale}/department_logos/logo' do
    get 'Returns logo of department' do
      tags 'Company'
      consumes 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :uuid,   in: :query, type: :string, required: true
      parameter name: :locale, in: :path,  type: :string, required: true, default: "en"
      response '200', 'OK' do

        let(:uuid) { @uuid }

        run_test!
      end

      response '400', 'Bad request' do

        let(:uuid) { 0 }

        run_test!
      end

    end
  end

  path '/{locale}/department_logo/{uuid}' do
    delete 'Destroy department logo' do
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
      parameter name: :uuid,   in: :path, type: :string, required: true

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

end