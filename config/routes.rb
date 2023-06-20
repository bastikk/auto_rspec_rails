Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get 'some/profile', to: 'application#index'
  get 'some/prof', to: 'application#show'
end
