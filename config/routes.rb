# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#top'
  resources :scraps do
    resources :comments, only: %i[create destroy], shallow: true
  end

  resources :bookmarks, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
