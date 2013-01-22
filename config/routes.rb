ChordateUi::Application.routes.draw do
  resources :users, :only => [:new, :create]
  resources :sessions, :only => [:new, :create]

  resources :applications do
    resources :users, :only => [:index]
    resources :events, :only => [:index]
    resources :filters, :only => [:index]
  end

  get '/dashboard' => 'dashboards#index'

  root :to => 'sessions#new'
end
