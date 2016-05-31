Rails.application.routes.draw do
  mount Knock::Engine => '/api/auth'
  scope :api, constraints: { format: 'json' } do
    resources :statements
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
  end
  root 'static#index'
  match '*path', to: 'static#index', via: :all
end
