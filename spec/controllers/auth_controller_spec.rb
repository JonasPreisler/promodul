RSpec.describe AuthController, type: :controller do
  describe 'POST /auth' do
    describe 'success login' do
      describe 'with username/username and password' do
        it 'returns JWT token with username' do
          credentials = {
            username: Faker::Internet.user_name,
            password: Faker::Internet.password
          }

          create(:user, username: credentials[:username], password: credentials[:password])

          post :login, params: credentials.merge({ locale: I18n.default_locale })
          body = parse_json_response(response.body)

          expect(body[:token]).not_to be nil
        end

        it 'returns JWT token with username' do
          credentials = {
            username: '555000111',
            password: Faker::Internet.password
          }

          create(:user, username: credentials[:username], password: credentials[:password])

          post :login, params: credentials.merge({ locale: I18n.default_locale })
          body = parse_json_response(response.body)

          expect(body[:token]).not_to be nil
        end
      end

      # DHP-78
      describe 'with hash' do
        it 'returns jwt token if valid hash' do
          credentials = {
            username: Faker::Internet.user_name,
            password: Faker::Internet.password,
          }

          auth_token = SecureRandom.hex(10)

          user = create(:user,
            username: credentials[:username],
            password: credentials[:password],
          )

          storage = TokenStorage::AutoLoginTokenService.new

          storage.store_auth_token(auth_token, user.id)

          headers = { 'Authorization' => "Bearer #{ auth_token }" }

          request.headers.merge!(headers)

          post :login, params: { username: credentials[:username],
                                 password: credentials[:password] }.merge({ locale: I18n.default_locale })

          body = parse_json_response(response.body)

          expect(body[:token]).not_to be nil
        end

        it 'deletes hash from redis' do
          credentials = {
            username:  Faker::Internet.user_name,
            password: Faker::Internet.password,
          }

          auth_token = SecureRandom.hex(10)

          user = create(:user,
            username: credentials[:username],
            password: credentials[:password],
          )

          storage = TokenStorage::AutoLoginTokenService.new

          storage.store_auth_token(auth_token, user.id)

          headers = { 'Authorization' => "Bearer #{ auth_token }" }

          request.headers.merge!(headers)

          post :login, params: { username: credentials[:username],
                                 password: credentials[:password]}.merge({ locale: I18n.default_locale })

          expect(storage.find_auth_token(auth_token)).not_to be_empty
        end
      end
    end

    describe 'login failed' do

      it 'returns 400 if not valid params' do
        credentials = {
          username: Faker::Internet.username,
          password: Faker::Internet.password
        }

        create(:user, username: credentials[:username], password: credentials[:password])

        post :login, params: { locale: I18n.default_locale }

        expect(response.status).to eq(400)
      end

      # DHP-78
      it 'returns 400 if hash not valid' do
        credentials = {
          username: Faker::Internet.username,
          password: Faker::Internet.password,
        }

        auth_token = SecureRandom.hex(10)

        user = create(:user,
          username: credentials[:username],
          password: credentials[:password],
        )

        post :login, params: { locale: I18n.default_locale }

        expect(response.status).to eq(400)
      end
    end

    # DHP-122
    describe 'login locked' do
      it 'clears login failure counter' do
        user_name = Faker::Internet.username
        pass =  Faker::Internet.password
        credentials = {
            username: user_name,
            password: Faker::Internet.password
        }

        right_credentials = {
            username: user_name,
            password: pass
        }

        create(:user, username: credentials[:username], password: pass)

        (LOGIN_FAILURE_SETTINGS.keys.first - 1).times do
          post :login, params: credentials.merge({ locale: I18n.default_locale })
        end

        post :login, params: right_credentials.merge({ locale: I18n.default_locale })
        user = UserAccount.where(username: credentials[:username]).or(UserAccount.where(username: credentials[:username])).first

        expect(user.failed_logins_count).to be(0)
      end

      it 'returns user is FINALLY locked error' do
        credentials = {
            username: Faker::Internet.username,
            password: Faker::Internet.password
        }

        create(:user, username: credentials[:username], password: Faker::Internet.password)

        (LOGIN_FAILURE_SETTINGS.key('forever') + LOGIN_FAILURE_SETTINGS.keys.length).times do |digit|
          user = UserAccount.where(username: credentials[:username]).or(UserAccount.where(username: credentials[:username])).first

          LOGIN_FAILURE_SETTINGS.each do |key, value|
            if digit == key + 1 && user.present? && user.last_attempt_date.present?
              user.last_attempt_date -= (value + 60*60).seconds if value != 'forever'
              user.save!
            end
          end

          post :login, params: credentials.merge({ locale: I18n.default_locale })
        end

        body = JSON.parse(response.body)

        error_text = I18n.t('errors.final_security_error')
        error_returned = body["errors"][0]["message"]
        expect(error_returned).to eq(error_text)
      end

      it 'returns user is locked error in case of right login credentials' do
        user_name = Faker::Internet.username
        pass =  Faker::Internet.password
        credentials = {
            username: user_name,
            password: Faker::Internet.password
        }

        right_credentials = {
            username: user_name,
            password: pass
        }

        create(:user, username: right_credentials[:username], password: pass)

        (LOGIN_FAILURE_SETTINGS.key('forever') + LOGIN_FAILURE_SETTINGS.keys.length).times do |digit|
          user = UserAccount.where(username: credentials[:username]).or(UserAccount.where(username: credentials[:username])).first

          LOGIN_FAILURE_SETTINGS.each do |key, value|
            if digit == key + 1 && user.present?
              user.last_attempt_date -= (value + 60*60).seconds if value != 'forever'
              user.save! if user.present?
            end

          post :login, params: credentials.merge({ locale: I18n.default_locale })
          end
        end

        post :login, params: right_credentials.merge({ locale: I18n.default_locale })

        body = JSON.parse(response.body)

        error_text = I18n.t('errors.final_security_error')
        error_returned =  body["errors"][0]["message"]
        expect(error_returned).to eq(error_text)
      end
    end

  end

  describe 'POST /refresh_token' do
    describe 'success refresh_token' do
      before do
        @credentials = {
          username: Faker::Internet.username,
          password: Faker::Internet.password
        }

        create(:user, username: @credentials[:username], password: @credentials[:password])
      end

      it 'returns new JWT token if refresh_token if valid' do
        stub_const("JWT_TOKEN_EXPIRED_MIN", 0)
        stub_const("REFRESH_TOKEN_EXPIRED_MIN", 3)

        result = Auth::Service.new.auth_current_user!(@credentials)

        refresh_token = result.content.dig(:data, :refresh_token)

        headers = { 'Authorization' => "Bearer #{ refresh_token }" }

        request.headers.merge!(headers)

        post :refresh_token, params: { locale: I18n.default_locale }

        body = parse_json_response(response.body)

        expect(body.dig(:data, :refresh_token)).not_to eq(refresh_token)
      end
    end

    describe 'failed refresh_token' do
      before do
        @credentials = {
          username: Faker::Internet.username,
          password: Faker::Internet.password
        }

        create(:user, username: @credentials[:username], password: @credentials[:password])
      end

      it 'returns 401 if refresh_token is not valid' do
        stub_const("JWT_TOKEN_EXPIRED_MIN", 0)
        stub_const("REFRESH_TOKEN_EXPIRED_MIN", 0)

        result = Auth::Service.new.auth_current_user!(@credentials)

        refresh_token = result.content.dig(:data, :refresh_token)

        headers = { 'Authorization' => "Bearer #{ refresh_token }" }

        request.headers.merge!(headers)

        post :refresh_token, params: { locale: I18n.default_locale }

        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE /logout' do
    describe 'success logout' do
      before do
        @credentials = {
          username: Faker::Internet.username,
          password: Faker::Internet.password
        }

        @user = create(:user, username: @credentials[:username], password: @credentials[:password])
      end

      it 'logs user out' do

        result = Auth::Service.new.auth_current_user!(@credentials)

        refresh_token = result.content.dig(:data, :refresh_token)
        storage = TokenStorage::RefreshTokenService.new(@user.id)

        headers = { 'Authorization' => "Bearer #{ refresh_token }" }
        request.headers.merge!(headers)
        delete :logout, params: { locale: I18n.default_locale }

        expect(storage.find_refresh_token(refresh_token)).to be_empty

      end
    end

    describe 'failed refresh_token' do
      before do
        @credentials = {
          username: Faker::Internet.username,
          password: Faker::Internet.password
        }

        create(:user, username: @credentials[:username], password: @credentials[:password])
      end

      it 'returns 401 if logout with wrong refresh_token' do
        headers = { 'Authorization' => "Bearer wrong_token.0010020063004005006.wrong_token" }
        request.headers.merge!(headers)
        delete :logout, params: { locale: I18n.default_locale }

        expect(response.status).to eq(401)
      end
    end
  end
end
