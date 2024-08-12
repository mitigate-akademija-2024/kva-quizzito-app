Rails.application.routes.draw do
  get 'users/profile'
  get 'highscores/index'
  get 'pages/start'
  
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
    post '/users/sign_up' => 'devise/registrations#create'
  end

  resources :quizzes do
    resources :questions do
      resources :user_answers, only: [:create]
    end

    member do
      post 'submit_answers'
      get 'review'
      get 'results'
      delete 'reset_answers'
    end
  end

  root 'pages#start'  # Set the start page as the root
  
  get 'my_quizzes', to: 'quizzes#my_quizzes'
  get 'highscores', to: 'highscores#index'
  get 'profile', to: 'users#profile', as: 'user_profile'
end
