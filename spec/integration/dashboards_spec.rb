require 'swagger_helper'

describe 'Clients', type: :request do

  path '/{locale}/dashboards/view' do
    get 'Dashboard data' do
      tags 'Dashboard'
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

      response '201', 'ok' do
        schema type: :object,
               properties: {
                   projects: {
                       type: :object,
                       properties: {
                           finished:      {type: :number},
                           current: { type: :number},
                           scheduled: { type: :number},
                           total: { type: :number},
                       }
                   },
                   tasks: {
                       type: :object,
                       properties: {
                           open:      {type: :number},
                           in_progress: { type: :number},
                           done: { type: :number},
                           total: { type: :number},
                       }
                   },
                   resources: {
                       type: :object,
                       properties: {
                           machine:      {type: :number},
                           tool: { type: :number},
                           external: { type: :number},
                           total: { type: :number},
                       }
                   },
                   users: {
                       type: :object,
                       properties: {
                           project_manager:      {type: :number},
                           employee: { type: :number},
                           total: { type: :number},
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