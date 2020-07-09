Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "health#check_health"

  scope "/:locale" do
    defaults format: :json do
      post   'auth/refresh_token'
      post   'auth', to: 'auth#login'
      delete 'auth', to: 'auth#logout'

      post   'account/registration', to: 'account/registration#sign_up'
      put    'account/registration', to: 'account/registration#confirm_registration'
      delete 'account/registration', to: 'account/registration#cancel_registration'

      post 'account/registration/sms_code'
      get 'account/registration/customer_types'

    end
  end
end
