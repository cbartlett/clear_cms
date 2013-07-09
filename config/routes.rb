ClearCMS::Engine.routes.draw do


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
