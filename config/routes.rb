Rails.application.routes.draw do
  mount Knock::Engine => '/api/auth'
  scope :api, constraints: { format: 'json' } do
    resources :users do
      get 'current', on: :collection 
    end
    resources :policies
    resources :clients
    resources :agencies
  end
  root 'static#index'
  match '*path', to: 'static#index', via: :all
end
