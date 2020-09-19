require 'swagger_helper'
require_relative  '../helpers/integration_methods'

describe 'ProductImage', type: :request do

  path '/{locale}/product_images' do
    post 'Create image of Product' do
      tags 'ProductImage'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :image,  in: :formData, type: :file,   required: true
      parameter name: :product_id,     in: :formData, type: :integer, required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '201', 'Created' do

        let(:product_image) { @category }
        let(:image) { @image }

        run_test!
      end

      response '400', 'Bad request' do

        let(:medicament_category) { 0 }
        let(:image) { @image }

        run_test!
      end

    end
  end

  path '/{locale}/product_image/image' do
    get 'Returns image of product image' do
      tags 'ProductImage'
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

  path '/{locale}/product_image/{uuid}' do
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