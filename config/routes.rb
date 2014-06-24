Rails.application.routes.draw do
  resources :links

  resources :posts
  get "parser", to: "posts#parser"
end
