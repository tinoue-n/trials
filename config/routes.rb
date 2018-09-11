Rails.application.routes.draw do
  root :to => 'top#index'
  get 'top/index' => 'top#index'
  post 'top/check' => 'top#check'
end
