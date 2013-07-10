ClearCMS::Engine.routes.draw do

  devise_for :users, 
  	:class_name => "ClearCMS::User",
  	:path => '',
  	:path_prefix => nil,
		failure_app:  'ClearCMS::Devise::FailureApp',
    controllers:  { sessions: 'clear_cms/sessions', passwords: 'clear_cms/passwords' }

  devise_scope :users do
    match '/'         => 'sessions#new'
    delete 'signout'  => 'sessions#destroy', as: :destroy_user_session
  end 	

	match "email" => "contents#email"

	root :to=>"users#dashboard"

	resources :sites do 
	  resources :contents
	  resources :assets
	end

	resources :contents do 
	  collection do 
	    post 'import'
	  end
	end

	resources :assets, :only=>[:show]    
	resources :users


end
