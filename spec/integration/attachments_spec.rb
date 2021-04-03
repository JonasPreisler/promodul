require 'swagger_helper'
require_relative  '../helpers/integration_methods'

describe 'Attachment', type: :request do

  path '/{locale}/attachments' do
    post 'Create file' do
      tags 'Attachment'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :file,  in: :formData, type: :file,   required: true
      parameter name: :attached_on_id,     in: :formData, type: :integer, required: true
      parameter name: :attached_on_type,     in: :formData, type: :string, required: true
      parameter name: :exp_date,     in: :formData, type: :string, required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '201', 'Created' do

        schema type: :object,
               properties: {
                   success: { type: :boolean }
               }

        run_test!
      end

      response '400', 'Bad request' do

        let(:medicament_category) { 0 }
        let(:image) { @image }

        run_test!
      end

    end
  end

  path '/{locale}/attachments/file' do
    get 'Returns file' do
      tags 'Attachment'
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

  path '/{locale}/attachments/get_files' do
    get 'Returns files' do
      tags 'Attachment'
      consumes 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :attached_on_type,   in: :query, type: :string, required: false
      parameter name: :attached_on_id,   in: :query, type: :string, required: false
      parameter name: :model_on_type,   in: :query, type: :string, required: false
      parameter name: :model_on_id,   in: :query, type: :string, required: false
      parameter name: :locale, in: :path,  type: :string, required: true, default: "en"
      response '200', 'OK' do

        schema type: :object,
               properties: {
                   files: {
                       type: :object,
                       properties: {
                           Resource: {
                               type: :object,
                               properties: {
                                   ToolModel: {
                                       type: :array,
                                       items: {
                                           properties: {
                                               id: { type: :integer},
                                               uuid: { type: :string},
                                               pol_type: { type: :string},
                                               type_on: { type: :string},
                                               name: { type: :string},
                                               file_name: { type: :string}
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

        let(:uuid) { 0 }

        run_test!
      end

    end
  end

  path '/{locale}/attachment/{uuid}' do
    delete 'Destroy product image' do
      tags 'ProductImage'
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