Rails.application.routes.draw do
  mount Knock::Engine => '/api/auth'
  scope :api, constraints: { format: 'json' } do
    resources :statements do
      get 'pdf', on: :member
      get 'xls', on: :member
    end
    resources :users do
      get 'current', on: :collection 
    end
    resources :policies
    resources :clients do
      get 'pdf', on: :collection
      get 'xls', on: :collection
    end
    resources :agencies
    resources :commissions do
      get 'pdf', on: :collection
      get 'xls', on: :collection
      post 'import', on: :collection
    end
    resources :orders
  end
  root 'static#index'
  match '*path', to: 'static#index', via: :all
end
