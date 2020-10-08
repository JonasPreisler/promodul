Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: "health#check_health"

  scope "/:locale" do
    defaults format: :json do
      post   'auth/refresh_token'
      post   'auth', to: 'auth#login'
      delete 'auth', to: 'auth#logout'

      post   'account/registration', to: 'account/registration#sign_up'
      put    'account/registration', to: 'account/registration#confirm_registration'
      delete 'account/registration', to: 'account/registration#cancel_registration'
      post   'account/registration', to: 'account/registration#create_customer'

      post    'account/registration/sms_code'
      get     'account/registration/customer_types'

      post    'suppliers', to: 'suppliers#create'
      put     'supplier/:id', to: 'suppliers#update'
      delete  'supplier/:id', to: 'suppliers#destroy'
      get     'suppliers/:id', to: 'suppliers#list'
      get     'supplier/business_types', to: 'suppliers#business_types'
      get     'supplier/integration_systems', to: 'suppliers#integration_systems'

      resource :categories
      get 'categories/category_list', to: 'categories#list'

      resource :sub_categories
      get 'sub_categories/sub_category_list', to: 'sub_categories#list'

      resource :products
      get 'products/list', to: 'products#list'
      get 'products/product_type', to: 'products#product_type'
      get 'products/product_vat_type', to: 'products#product_vat_type'
      post 'products/import_products', to: 'products#import_products'
      get 'products/edit_product', to: 'products#edit_product'

      resource :product_images
      get  'product_image/image', to: 'product_images#show_image'
      delete  'product_image/:uuid', to: 'product_images#destroy'

      resource :terms_and_conditions
      get 'terms_and_conditions/list', to: 'terms_and_conditions#list'

      resource :product_types
      get 'product_types/product_type_list', to: 'product_types#list'

      resource :currencies
      get 'currencies/currencies_list', to: 'currencies#list'

      resource :supplier_products
      get 'supplier_products/list', to: 'supplier_products#list'

      resource :product_prices
      get 'product_prices/price', to: 'product_prices#price'
      get 'product_prices/:id', to: 'product_prices#show'

      post 'settings/country', to: 'settings#country'
      post 'settings/city', to: 'settings#city'
      get 'settings/countries', to: 'settings#countries'
      get 'settings/cities', to: 'settings#cities'
      delete  'settings/destroy_country', to: 'settings#destroy_country'
      delete  'settings/destroy_city', to: 'settings#destroy_city'

      resource :companies
      get 'companies/company_list', to: 'companies#company_list'
      get 'companies/sub_company_list', to: 'companies#sub_company_list'
    end
  end
end
