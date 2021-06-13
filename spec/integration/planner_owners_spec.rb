require 'swagger_helper'

describe 'Planner owners dashboard', type: :request do

  path '/{locale}/planner_owners/dashboard' do
    get 'Dashboard data' do
      tags 'Owner'
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
                           admin: { type: :number},
                           total: { type: :number},
                       }
                   },
                   companies: {
                       type: :object,
                       properties: {
                           active_companies:      {type: :number},
                           not_active_companies: { type: :number},
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

  path '/{locale}/planner_owners/companies' do
    get 'Company list' do
      tags 'Owner'
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
                   companies: {
                       type: :object,
                       properties: {
                           id: { type: :number },
                           name: { type: :string },
                           address: { type: :string },
                           phone_number: { type: :string },
                           active: { type: :boolean }
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

  path '/{locale}/planner_owners/stop_license/{company_id}' do
    post 'Stop company license' do
      tags 'Owner'
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
      parameter name: :company_id, in: :path, type: :integer, required: true

      response '201', 'ok' do
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

  path '/{locale}/planner_owners/activate_license/{company_id}' do
    post 'Stop company license' do
      tags 'Owner'
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
      parameter name: :company_id, in: :path, type: :integer, required: true

      response '201', 'ok' do
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