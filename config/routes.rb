Rails.application.routes.draw do

  root to: "home#index"

  get 'consulta' => 'home#consulta'
  get 'status' => 'home#status'

  resources :blocks do
  end

end
