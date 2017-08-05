Rails.application.routes.draw do
  resources :detail_twos
  resources :details
  
 root 'details#home'
  	

#For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
