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
              first_name: {type: :string},
              last_name: {type: :string},
              birth_date: {type: :string, format: :date},
              phone_number: {type: :string},
              email: {type: :string},
              password: {type: :string},
              password_confirmation: {type: :string}
          },required: [:first_name, :last_name, :birth_date, :phone_number, :username, :password, :password_confirmation]
      }
      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      response '200', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean }
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