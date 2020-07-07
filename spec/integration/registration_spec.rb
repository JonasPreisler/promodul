require 'swagger_helper'

describe 'Registration ', type: :request do
  path '/{locale}/account/registration' do
    post 'UserAccount Account registration' do
      tags 'Registration'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name: {type: :string},
              delivery_address: {type: :string},
              invoice_address: {type: :string},
              username: {type: :string},
              phone_number: {type: :string},
              phone_number_iso: {type: :string},
              email: {type: :string},
              password: {type: :string},
              password_confirmation: {type: :string},
              agreed_terms_and_conditions: {type: :boolean},
              terms_and_conditions_id: {type: :integer}
          },required: [:name, :delivery_address, :invoice_address, :phone_number, :username, :password, :password_confirmation, :agreed_terms_and_conditions, :terms_and_conditions_id]
      }
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '200', 'OK' do

        schema type: :object,
               properties: {
                   confirmation_token: { type: :string }
               }
        let(:params) do
          {
              first_name: Faker::Name.first_name,
              username: "12345678",
              last_name: Faker::Name.last_name,
              birth_date: Faker::Date.birthday,
              phone_number: Faker::Number.number(9),
              email: Faker::Internet.email,
              password: "Pass1234",
              password_confirmation: "Pass1234"
          }
        end

        run_test!
      end

      response '400', 'Bad request' do
        schema type: :object,
               properties: {
                   errors: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               message: { type: :string },
                               code:    { type: :integer},
                               field:   { type: :string }
                           }
                       }
                   }
               }

        run_test!
      end
    end
  end

  path '/{locale}/account/registration' do
    put 'Confirm registration' do
      tags 'Registration'
      consumes 'application/json'

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              sms_code: {type: :string},
              token: {type: :string}
          },required: [:sms_code, :token]
      }
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '200', 'OK' do
        schema type: :object,
               properties: {
                   token: {
                       type: :string,
                   },

               }

        let(:params) do {
            sms_code: Faker::Number.number(6),
            token: SecureRandom.hex(10)
        }
        end
        before do
          user = FactoryBot.create(:umg_user_account)
          FactoryBot.create(:umg_confirmation_code, umg_user_account_id: user.id, retry_count: 1, confirmation_token: params[:token],
                            sms_code: params[:sms_code])
        end
        run_test!
      end

      response '400', 'Bad request' do

        let(:params) do {
            sms_code: Faker::Number.number(6),
            token: nil
        }
        end
        before do
          user = FactoryBot.create(:umg_user_account)
          FactoryBot.create(:umg_confirmation_code, umg_user_account_id: user.id, retry_count: 1, confirmation_token: params[:token],
                            sms_code: params[:sms_code])
        end
        run_test!
      end
    end
  end

  path '/{locale}/account/registration/sms_code' do
    post 'Get new sms code' do
      tags 'Registration'
      consumes 'application/json'
      parameter name: :locale, in: :path, type: :string, required: true, default: "ka"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              token: {type: :string}
          },required: [:token]
      }
      response '204', 'No content' do
        let(:params) {{ token: SecureRandom.hex(10) }}
        before do
          user = FactoryBot.create(:user_account)
          FactoryBot.create(:confirmation_code, user_account_id: user.id, retry_count: 1, confirmation_token: params[:token])
        end
        run_test!
      end
      response '400', 'Bad request' do
        let(:params) {{ token: nil }}
        before do
          user = FactoryBot.create(:user_account)
          FactoryBot.create(:confirmation_code, user_account_id: user.id, retry_count: 1, confirmation_token: params[:token])
        end
        run_test!
      end
    end
  end
end