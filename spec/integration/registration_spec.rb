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
              username: {type: :string},
              first_name: {type: :string},
              last_name: {type: :string},
              birth_date: {type: :string, format: :date},
              phone_number: {type: :string},
              phone_number_iso: {type: :string},
              email: {type: :string},
              password: {type: :string},
              password_confirmation: {type: :string},
              agreed_terms_and_conditions: {type: :boolean},
              terms_and_conditions_id: {type: :integer}
          },required: [:first_name, :last_name, :birth_date, :phone_number, :username, :password, :password_confirmation, :agreed_terms_and_conditions, :terms_and_conditions_id]
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
end