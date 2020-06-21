require 'swagger_helper'

describe 'Auth', type: :request do

  path '/{locale}/auth' do

    post 'Auth user with credentials' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :description => 'Client token'
                })

      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              username: { type: :string },
              password: { type: :string },
              #device_token: { type: :string },
          }, required: [:username, :password]
      }
      parameter name: :locale,     in: :path, type: :string, default: "en"

      response '200', 'success' do
        let(:Authorization) { "Bearer #{ @token }" }
        let(:params) {
          {
              username: Faker::Internet.username,
              password: Faker::Internet.password,

          }
        }
        let(:locale){ I18n.default_locale.to_s }

        before do
          user = create(:user, password: "Password123")
          storage = TokenStorage::AutoLoginTokenService.new
          auth_token = SecureRandom.hex(10)
          storage.store_auth_token(auth_token, user.id)
          @token = auth_token
        end

        schema type: :object,
               properties: {
                   data: {
                       type: :object,
                       properties: {
                           token: { type: :string },
                           refresh_token: { type: :string },
                       },
                       required: [ 'token', 'refresh_token' ]
                   }
               }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer #{ @token }" }
        let(:params) {
          {
              username: Faker::Internet.username,
              password: Faker::Internet.password
          }
        }
        let(:locale){ I18n.default_locale.to_s }

        before do
          create(:user, username: Faker::Internet.username, password: Faker::Internet.password)
        end

        run_test!
      end

      response '401', 'Forbidden' do
        let(:Authorization) { "Bearer #{ @token }" }

        let(:params) {
          {
              username: "username",
              password: 'Password123'
          }
        }
        let(:locale){ I18n.default_locale.to_s }

        before do
          user = create(:user, username: 'username', password: "Password123", locked: true)
        end

        run_test!
      end
    end
  end

  path '/{locale}/auth' do

    delete 'UserAccount Logout' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      let(:auth_token) { SecureRandom.hex(10) }
      let(:"Authorization") { "Bearer #{ auth_token }" }

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale,     in: :path, type: :string, default: "en"

      response '200', 'Ok' do
        let(:params) {
          {
              username: Faker::Internet.username,
              password: Faker::Internet.password
          }
        }
        let(:locale){ I18n.default_locale.to_s }

        before do
          user = create(:user, username: params[:username], password: params[:password])
          storage = TokenStorage::AutoLoginTokenService.new
          storage.store_auth_token(auth_token, user.id)
        end

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:params) {
          {
              username: Faker::Internet.username,
              password: Faker::Internet.password
          }
        }
        let(:locale){ I18n.default_locale.to_s }

        before do
          create(:user, username: Faker::Internet.username, password: Faker::Internet.password)
        end

        run_test!
      end
    end
  end

  path "/{locale}/auth/refresh_token" do

    post "get new JWT  using refresh token" do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      let(:"Authorization") { "Bearer #{ @refresh_token }" }

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Refresh token'
                })
      parameter name: :locale,     in: :path, type: :string, default: "en"

      response '200', 'OK' do

        let(:locale){ I18n.default_locale.to_s }

        before do
          params = {username: "shota@mail.ru",password: "Pass1234"}
          user = create(:user,username: "shota@mail.ru",password: "Pass1234")
          result = Auth::Service.new.auth_current_user!(params)
          @refresh_token = result["content"][:data][:refresh_token]
        end


        schema type: :object,
               properties: {
                   data: {
                       type: :object,
                       properties: {
                           token: { type: :string },
                           refresh_token: { type: :string },
                       },
                       required: [ 'token', 'refresh_token' ]
                   }
               }

        run_test!

      end

      response '401', 'Unauthorized' do

        let(:Authorization){"Bearer "+ SecureRandom.hex(10)}
        let(:locale){ I18n.default_locale.to_s }

        before do
          params = {username: "shota@mail.ru",password: "Pass1234"}
          user = create(:user,username: "shota@mail.ru",password: "Pass1234")
          result = Auth::Service.new.auth_current_user!(params)
          @refresh_token = result["content"][:data][:refresh_token]
        end

        run_test!

      end

    end
  end

end
