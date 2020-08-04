require 'swagger_helper'

describe 'SubCategory', type: :request do

  path '/{locale}/sub_categories' do
    post 'Create medicament sub category' do
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
              category_id: {type: :integer},
              name:      {
                  type: :object,
                  properties: {
                      no: {type: :string},
                      en: {type: :string}
                  }
              },
              id_name:   {type: :string},
              active:    {type: :boolean}
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   sub_category: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string},
                       }
                   }
               }

        run_test!
      end

      response '404', 'Not Found' do

        #let(:id) { 0 }
        #let(:picture) { @picture }

        run_test!
      end

    end
  end

  path '/{locale}/sub_categories' do
    put 'Update sub category' do
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
              category_id: {type: :integer},
              name:      {
                  type: :object,
                  properties: {
                      no: {type: :string},
                      en: {type: :string}
                  }
              },
              id_name:   {type: :string},
              active:    {type: :boolean}
          }
      }
      response '200', 'ok' do
        schema type: :object,
               properties: {
                   sub_category: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string},
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

  path '/{locale}/sub_categories/sub_category_list' do
    get 'Returns sub categories' do
      tags 'Category and Sub category'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :category_id, in: :query, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   sub_categories: {
                       type: :array,
                       items: {
                           properties: {
                               name: {type: :string},
                               id_name: {type: :string},
                               priority: {type: :integer},
                               category_id: {type: :integer}
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

  path '/{locale}/sub_categories' do
    delete 'delete sub category' do
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

end