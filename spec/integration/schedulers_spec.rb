require 'swagger_helper'

describe 'Clients', type: :request do

  path '/{locale}/schedulers/view' do
    get 'Scheduler data' do
      tags 'Scheduler'
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
                   user_dates: {
                       type: :array,
                       items: {
                           properties: {
                               id:          { type: :integer  },
                               first_name:  { type: :string },
                               last_name:   { type: :string },
                               dates: {
                                   type: :object,
                                   properties: {
                                       start:     { type: :string },
                                       end:     { type: :string },
                                       assign_id:   { type: :string },
                                       title:     { type: :string },
                                       assign_type: { type: :string },
                                       status:   { type: :string }
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
end