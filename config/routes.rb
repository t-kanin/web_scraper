# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  resources :keywords do
    collection { post :import }
  end

  get 'keywords/:id/:status', to: 'keywords#show'
  root 'keywords#index'
end
