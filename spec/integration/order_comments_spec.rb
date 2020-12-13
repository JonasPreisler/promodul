require 'swagger_helper'

describe 'Order Comment', type: :request do

  path '/{locale}/order_comments' do
    post 'Create order comment' do
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
              comment:          { type: :string },
              user_account_id:  { type: :integer },
              order_id:         { type: :integer }

          }
      }
      response '200', 'OK' do
        schema type: :object,
               properties: {
                   comments: {
                       type: :array,
                       items: {
                           properties: {
                               id: { type: :integer },
                               comment: { type: :string },
                               created_at: { type: :string },
                               user_account: {
                                   type: :object,
                                   properties: {
                                       username: { type: :string }
                                   }
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

  path '/{locale}/order_comments/comments_list/{order_id}' do
    get 'Returns clients' do
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
      parameter name: :order_id, in: :path, type: :integer, required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   comments: {
                       type: :array,
                       items: {
                           properties: {
                               id: { type: :integer },
                               comment: { type: :string },
                               created_at: { type: :string },
                               user_account: {
                                   type: :object,
                                   properties: {
                                       username: { type: :string }
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