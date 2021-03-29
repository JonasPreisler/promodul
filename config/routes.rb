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
      post 'settings/machine_model', to: 'settings#machine_model'
      post 'settings/tool_model', to: 'settings#tool_model'
      post 'settings/external_source_type', to: 'settings#external_source_type'
      get 'settings/countries', to: 'settings#countries'
      get 'settings/cities', to: 'settings#cities'
      get 'settings/machine_models', to: 'settings#machine_models'
      get 'settings/tool_models', to: 'settings#tool_models'
      get 'settings/external_source_types', to: 'settings#external_source_types'
      delete  'settings/destroy_country', to: 'settings#destroy_country'
      delete  'settings/destroy_city', to: 'settings#destroy_city'
      delete  'settings/destroy_machine_model', to: 'settings#destroy_machine_model'
      delete  'settings/destroy_tool_model', to: 'settings#destroy_tool_model'
      delete  'settings/destroy_external_source_type', to: 'settings#destroy_external_source_type'

      resource :companies
      get 'companies/company_list', to: 'companies#company_list'
      get 'companies/sub_company_list', to: 'companies#sub_company_list'
      get 'companies/:id', to: 'companies#show'

      resource :company_logos
      get  'company_logos/logo', to: 'company_logos#show_logo'
      delete  'company_logo/:uuid', to: 'company_logos#destroy'

      resource :departments
      get 'departments/department_list', to: 'departments#department_list'
      get 'departments/sub_department_list', to: 'departments#sub_department_list'

      resource :department_logos
      get  'department_logos/logo', to: 'department_logos#show_logo'
      delete  'department_logo/:uuid', to: 'department_logos#destroy'

      resource :role_groups
      get 'role_groups/list', to: 'role_groups#list'
      get 'role_groups/get_role', to: 'role_groups#get_role'

      resource :user_roles

      get 'users/list', to: 'users#list'
      get 'users/unconfirmed_list', to: 'users#unconfirmed_list'
      get 'users/current_user', to: 'users#current_user'
      get 'users/listen_to_unconfirmed_users', to: 'users#listen_to_unconfirmed_users'
      post 'users/approve_registration', to: 'users#approve_registration'

      resource :clients
      get 'clients/client_type',  to: 'clients#client_type'
      get 'clients/client_group', to: 'clients#client_group'
      get 'clients/clients_list', to: 'clients#clients_list'
      get 'clients/:id',          to: 'clients#show'

      resource :client_contacts
      get 'client_contacts/contacts_list', to: 'client_contacts#contacts_list'
      get 'client_contacts/:id',          to: 'client_contacts#show'

      resource :orders
      get 'orders/order_type',  to: 'orders#order_type'
      get 'orders/orders_list', to: 'orders#orders_list'
      get 'orders/open_orders_list', to: 'orders#open_orders_list'
      get 'orders/:id',         to: 'orders#show'
      get 'orders/overview/:id', to: 'orders#overview'
      get 'orders/my_orders_list/:user_account_id', to: 'orders#my_orders_list'
      get 'orders/all_orders_list', to: 'orders#all_orders_list'
      post 'orders/claim_order',         to: 'orders#claim_order'

      resource :order_products
      get 'order_products/product_order_list',       to: 'order_products#product_order_list'
      get 'order_products/order_products_list/:id',  to: 'order_products#order_products_list'
      get 'order_products/:id',                      to: 'order_products#show'

      resource :tasks
      get 'tasks/tasks_list/:id', to: 'tasks#tasks_list'
      get 'tasks/status_progress/:id', to: 'tasks#status_progress'
      get 'tasks/:id',                      to: 'tasks#show'

      resource :order_comments
      get 'order_comments/comments_list/:order_id', to: 'order_comments#comments_list'

      resource :resources
      get 'resources/resource_list',       to: 'resources#resource_list'
      get 'resources/resource_type_list',       to: 'resources#resource_type_list'

      resource :attachments
      get  'attachments/file', to: 'attachments#show_file'
      delete  'attachments/:uuid', to: 'attachments#destroy'

    end
  end
end
