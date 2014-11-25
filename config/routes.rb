Secretsanta::Application.routes.draw do
  resources :people
  
  get 'redo' => 'people#redo', as: :redo
  get 'email' => 'people#email_everyone', as: :email_everyone
  get 'email_by_name/:name' => 'people#email_by_name', as: :email_by_name
  get 'reset' => 'people#reset', as: :reset

  get 'admin' => 'people#admin', as: :admin
  post 'admin' => 'people#admin_login', as: :admin_login

  root to: 'people#index'
end
