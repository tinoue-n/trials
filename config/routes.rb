Rails.application.routes.draw do
  root :to => 'top#index'
  get 'index' => 'top#index'
  get 'check' => 'top#index'
  post 'check' => 'top#check'
  mount Cards::Root => "/"
end