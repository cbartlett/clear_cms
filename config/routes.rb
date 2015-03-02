ClearCMS::Engine.routes.draw do

  root :to=>"users#dashboard"

  devise_for :users,
  	:class_name => "ClearCMS::User",
  	:path => '',
  	:path_prefix => nil,
		failure_app:  'ClearCMS::Devise::FailureApp',
    controllers:  { sessions: 'clear_cms/sessions', passwords: 'clear_cms/passwords', unlocks: 'clear_cms/unlocks' }

  devise_scope :users do
    get '/'         => 'sessions#new'
    #delete 'signout'  => 'sessions#destroy', as: :destroy_user_session
  end

	get "email" => "contents#email"

	resources :sites do
	  resources :contents
	  resources :assets
	end

  resources :contents do
    collection do
      post 'import'
    end
    resources :history_trackers
  end

  resources :assets, :only=>[:show]
  resources :users
  resources :history_trackers, :only=>[:update]
  resources :form_fields, :only=>[:index]

  get '/ember' => 'contents#ember', :as=>:ember_app

end
