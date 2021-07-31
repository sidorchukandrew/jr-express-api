Rails.application.routes.draw do
  resources :contacts
  resources :addresses
  resources :invoices do 
    post "/email", to: "invoices#email"
  end

  get "/invoice_numbers", to: "invoice_numbers#next_number"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/email_settings", to: "email_settings#show"
  post "/email_settings", to: "email_settings#create"
  put "/email_settings", to: "email_settings#update"

  post "/login", to: "auth#login"
end
