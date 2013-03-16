Ombtraining::Application.routes.draw do


  resources :qcms, only: [:update, :edit, :destroy] do
    match '/order_plus', to: 'qcms#order_plus',
      as: :order_plus
    match '/order_minus', to: 'qcms#order_minus',
      as: :order_minus
    match '/manage_choices', to: "qcms#manage_choices"
    match '/add_choice', to: "qcms#add_choice"
    match '/remove_choice/:id', to: "qcms#remove_choice", as: :remove_choice
    match '/switch_choice/:id', to: "qcms#switch_choice", as: :switch_choice
  end
  
  resources :exercises, only: [:update, :edit, :destroy] do
    match '/order_plus', to: 'exercises#order_plus',
      as: :order_plus
    match '/order_minus', to: 'exercises#order_minus',
      as: :order_minus
  end


  resources :theories, only: [:update, :edit, :destroy] do
    match '/order_plus', to: 'theories#order_plus',
      as: :order_plus
    match '/order_minus', to: 'theories#order_minus',
      as: :order_minus
  end
  
  resources :problems, only: [:update, :edit, :destroy] do
    match '/order_plus', to: 'problems#order_plus',
      as: :order_plus
    match '/order_minus', to: 'problems#order_minus',
      as: :order_minus
  end

  mathjax 'mathjax'
  resources :prerequisites
  
  match '/graph', to: "prerequisites#graph"

  resources :sections

  resources :chapters do
    match '/manage_sections', to: 'chapters#new_section'
    match '/add_section/:id', to: 'chapters#create_section',
      as: :add_section
    match '/remove_section/:id', to: 'chapters#destroy_section',
      as: :remove_section
      
    resources :theories, only: [:new, :create]
    resources :exercises, only: [:new, :create]
    resources :qcms, only: [:new, :create]
    resources :problems, only: [:new, :create]
  end

  resources :users do
    match '/add_administrator', to: 'users#create_administrator',
      as: :add_administrator
  end
  
  resources :sessions, only: [:new, :create, :destroy]

  root to: 'static_pages#home'

  match '/help', to: 'static_pages#help'

  match '/about', to: 'static_pages#about'

  match '/contact', to: 'static_pages#contact'

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

end