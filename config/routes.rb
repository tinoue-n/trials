Rails.application.routes.draw do
  root :to => 'top#index'
  get 'index' => 'top#index'
  post 'check' => 'top#check'
end
