require 'swagger_helper'

describe 'ProductPrice ', type: :request do
  path '/{locale}/product_prices' do
    post 'Create product price' do
      tags 'Product'
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
              product_id:         { type: :integer },
              list_price_type:    { type: :string },
              list_price_amount:  { type: :number },
              manufacturing_cost: { type: :number }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   price_data: {
                       type: :object,
                       properties: {
                           manufacturing_cost:  { type: :number },
                           purchase_price:      { type: :number},
                           cost_price:          { type: :number },
                           list_price:          { type: :number },
                           supplier:            { type: :string }
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

  path '/{locale}/product_prices/price' do
    get 'Returns product prices by supplier' do
      tags 'Product'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :product_id, in: :query,  type: :integer,  required: true

      response '201', 'ok' do
        schema type: :object,
               properties: {
                   price_data: {
                       type: :object,
                       properties: {
                           manufacturing_cost:  { type: :number },
                           purchase_price:      { type: :number},
                           cost_price:          { type: :number },
                           list_price:          { type: :number },
                           supplier:            { type: :string }
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

  path '/{locale}/product_prices/{product_id}' do
    get 'Returns product price' do
      tags 'Product'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'JWT token'
                })

      parameter name: :product_id, in: :path, type: :integer, required: true
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"

      response '201', 'ok' do
        schema type: :object,
               properties: {
                   product_price: {
                       type: :object,
                       properties: {
                           manufacturing_cost:  { type: :number },
                           list_price_type:     { type: :string },
                           list_price_amount:   { type: :number }
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

end


