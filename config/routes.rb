ChordateUi::Application.routes.draw do
  resources :users, :only => [:new, :create]
  resources :sessions, :only => [:new, :create]

  resources :applications do
    resources :events, :only => [:index]
  end

  get '/dashboard' => 'dashboards#index'

  root :to => 'sessions#new'
end
