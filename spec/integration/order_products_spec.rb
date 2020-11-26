require 'swagger_helper'

describe 'Clients', type: :request do

  path '/{locale}/order_products' do
    post 'Create Order product' do
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
              order_id:    { type: :integer },
              product_id:  { type: :integer },
              count:       { type: :integer }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   order_product: {
                       type: :object,
                       properties: {
                           id:         {type: :integer},
                           count:      {type: :integer},
                           product: {
                               type: :object,
                               properties: {
                                   name: { type: :string },
                                   full_name: { type: :string },
                                   code: { type: :string}
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

  path '/{locale}/order_products/product_order_list' do
    get 'Returns products' do
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

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   products: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               name: { type: :string },
                               full_name: { type: :string },
                               code: { type: :string}
                           }
                       }
                   }
               }
        run_test!
      end

    end
  end

  path '/{locale}/order_products/order_products_list/{order_id}' do
    get 'Returns order products' do
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
                   products: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               count:      {type: :integer},
                               product: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string },
                                       full_name: { type: :string },
                                       code: { type: :string}
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

  path '/{locale}/order_products/order_products_list/{order_id}' do
    get 'Returns order products' do
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
                   products: {
                       type: :array,
                       items: {
                           properties: {
                               id:         {type: :integer},
                               count:      {type: :integer},
                               product: {
                                   type: :object,
                                   properties: {
                                       name: { type: :string },
                                       full_name: { type: :string },
                                       code: { type: :string}
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

  path '/{locale}/order_products/{id}' do
    get 'Returns order_product' do
      tags 'Order'
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
                   order_product: {
                       type: :object,
                       properties: {
                           id:         {type: :integer},
                           count:      {type: :integer},
                           product: {
                               type: :object,
                               properties: {
                                   name: { type: :string },
                                   full_name: { type: :string },
                                   code: { type: :string}
                               }
                           }
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

  path '/{locale}/order_products' do
    put 'Update order product' do
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
              id:     {type: :integer},
              count:  { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   order_product: {
                       type: :object,
                       properties: {
                           id:         {type: :integer},
                           count:      {type: :integer},
                           product: {
                               type: :object,
                               properties: {
                                   name: { type: :string },
                                   full_name: { type: :string },
                                   code: { type: :string}
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

  path '/{locale}/order_products' do
    delete 'Delete order product' do
      tags 'Order'
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