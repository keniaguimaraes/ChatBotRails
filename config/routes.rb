Rails.application.routes.draw do
  resources :messages
  #get 'callback/index'
  post '/' => 'callback#recieved_data'
  get 'callback/recieved_data'
  resources :callback
  resources :assistant
  root 'callback#index'
  root 'messages#index'
  	
  post '/messenger' => 'assistant#messenger'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
