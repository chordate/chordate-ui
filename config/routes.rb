ChordateUi::Application.routes.draw do
  resources :users,     :only => [:new, :create]
  resources :sessions,  :only => [:new, :create]

  resources :applications, :only => [:new, :index, :create, :show] do
    resources :users,   :only => [:index]
    resources :events,  :only => [:index]
    resources :filters, :only => [:index]
    resources :invites, :only => [:show, :create, :update]
  end

  namespace :v1, :module => :api do
    resources :applications, :only => [] do
      resources :events, :only => [:create, :update]
    end
  end

  get '/v1/applications/:application_id/events', :to => 'events#index'

  get '/dashboard' => 'dashboards#index'

  root :to => 'sessions#new'
end
