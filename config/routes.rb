Rails.application.routes.draw do
  # Docs
  apipie

  scope '/api/v1', except: [:new, :edit], defaults: { format: :json } do
    # Auth
    devise_for :staff, controllers: { sessions: 'sessions' }

    devise_scope :staff do
      match '/staff/auth/:provider/callback', to: 'sessions#create', via: [:get, :post], defaults: { format: :html }
    end

    resources :saml, only: :index do
      collection do
        get :init
        get :sso
        post :acs
        get :metadata
        get :logout
      end
    end

    # Alerts Routes
    resources :alerts do
      collection do
        post :sensu
      end
    end

    resources :wizard_questions, only: [:show, :create] do
      collection do
        get :first
      end
    end

    # User Setting Options Routes
    resources :user_setting_options, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :api_tokens, defaults: { format: :json }

    # Approvals
    resources :staff, only: [:index]
    resources :staff, only: [:show, :create, :update, :destroy] do
      # Staff Orders
      resources :orders, controller: :staff_orders, defaults: { format: :json, includes: %w(order_items) }, only: [:show, :index]

      collection do
        match 'current_member' => 'staff#current_member', via: :get
      end

      # Staff Settings (user_settings)
      resources :settings, controller: :staff_settings, only: [:index, :show, :create, :update, :destroy]
    end

    # Organizations
    resources :organizations

    # Provision Request Response
    resources :order_items, only: [:show, :update, :destroy] do
      member do
        put :start_service
        put :stop_service
        put :provision_update
        put :retire_service
      end
    end

    # Orders
    resources :orders, defaults: { includes: %w(order_items) } do
      member do
        get :items, defaults: { includes: [] }
      end
    end

    # Products
    resources :products do
      member do
        get :answers
      end
    end

    resources :manage_iq_products

    resources :product_types

    # Chargebacks
    resources :chargebacks

    # Clouds
    resources :clouds

    resources :bundles

    # Services (Alias for OrderItem)
    get 'services' => 'services#index', as: :services_index
    get 'services/order_profiles' => 'services#order_profiles', as: :services_order_profiles
    get 'services/count' => 'services#count', as: :services_count
    get 'services/all_count' => 'services#all_count', as: :services_all_count
    get 'services/project_count' => 'services#project_count', as: :services_project_count
    get 'services/:tag' => 'services#show', as: :services_show

    # Project Routes
    scope 'projects/:project_id' do
      post 'groups' => 'memberships#create', as: :memberships
      delete 'groups/:group_id' => 'memberships#destroy', as: :membership

      get 'approvals' => 'project_approvals#index', as: :project_approvals
      post 'approve' => 'project_approvals#update', as: :approve_project
      delete 'reject' => 'project_approvals#destroy', as: :reject_project
    end
    resources :projects

    # ProjectQuestion Routes
    resources :project_questions

    # Admin Settings
    resources :settings, defaults: { includes: %w(setting_fields)  }, only: [:index, :update, :show, :destroy]
    resources :settings, defaults: { includes: %w(setting_fields)  }, only: [:show], param: :hid

    # Automate Routes
    resources :automate, only: [] do
      collection do
        get :catalog_item_initialization
        get :update_servicemix_and_chef
        get :provision_rds

        get :create_ec2
        get :create_rds
        get :create_s3
        get :create_ses
        get :create_vmware_vm
        get :create_chef_node

        get :retire_ec2
        get :retire_rds
        get :retire_s3
        get :retire_ses
        get :retire_vmware_vm
      end
    end

    # Content Pages Routes
    resources :content_pages, only: [:index, :create]
    resources :content_pages, only: [:update, :show, :destroy], param: :slug
    patch 'content_pages/revert/:slug', to: 'content_pages#revert'

    resources :groups
    resources :roles, only: [:index, :create, :update, :destroy]
  end

  root 'welcome#index'

  # Forward all angular paths to angular app so that directly visiting a url or
  # refreshing the page works as expected
  %w(
    401-unauthorized
    404-not-found
    admin
    cart
    dashboard
    list
    login
    logout
    marketplace
    order
    orders
    project
    server-unreachable
    show
    terribly-sorry-about-that
    users
    wizard
  ).each do |path|
    get "/#{path}" => 'welcome#index'
    get "/#{path}/*path" => 'welcome#index'
  end
end
