Secretsanta::Application.routes.draw do
  resources :people

  post 'automatch' => 'people#automatch'
  post 'email' => 'people#email_everyone', as: :email_everyone
  post 'email/:id' => 'people#email', as: :email
  post 'reset' => 'people#reset', as: :reset

  get 'admin' => 'people#admin', as: :admin
  post 'admin' => 'people#admin_login', as: :admin_login

  root to: 'people#index'
end
