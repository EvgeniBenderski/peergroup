Peergroupsupervision::Application.routes.draw do
  resources :rules

  resources :chat_rooms do

    member do
      post :select_leader
      post :select_problem_owner
    end

    resources :chat_updates
    resources :chat_users
  end

  resources :users do
    member do
      get :following
      get :followers
    end
    resources :groups
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resource :relationships, :only => [:create, :destroy]

  resources :supervisions, :only => [:show, :index] do
    resources :topics, :only => :create do
      resources :votes, :only => :create, :controller => :topic_votes
    end
    resources :questions, :only => :create do
      resources :answers, :only => :create
    end
    resources :ideas, :only => [:create, :update]
    resources :ideas_feedbacks, :only => :create
    resources :solutions, :only => [:create, :update]
    resources :solutions_feedbacks, :only => :create
    resources :supervision_feedbacks, :only => :create
    resources :votes, :only => :create
  end

  resources :groups do
    resources :supervisions, :only => [:new, :create]
    resources :memberships
    resources :rules
  end

  match '/signin' => 'sessions#new', :as => 'signin'
  match '/signout' =>'sessions#destroy', :as => 'signout'
  match '/contact' => 'pages#contact', :as => 'contact'
  match '/about' => 'pages#about', :as => 'about'
  match '/help' => 'pages#help', :as => 'help'
  match '/signup' =>'users#new', :as => 'signup'

  root :to => 'pages#home'
end

