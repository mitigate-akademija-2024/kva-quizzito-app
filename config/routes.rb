Rails.application.routes.draw do
  get 'users/profile'
  get 'highscores/index'
  get 'pages/start'
  
  devise_for :users, skip: :sessions
    as :user do
      get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
      post 'sign_in', to: 'devise/sessions#create', as: :user_session
      delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
end

  resources :quizzes do
    member do
      get 'take'      # Route for taking the quiz
      post 'submit_results' # Route for submitting quiz answers
      get 'results'   # Route for viewing quiz results
      get 'finished', to: 'quizzes#quiz_finished', as: 'quiz_finished'
      get 'confirm_delete', to: 'quizzes#confirm_delete', as: 'confirm_delete' 

    end

    collection do
      get 'search', to: 'quizzes#search'
    end
    
    resources :questions do
      resources :user_answers, only: [:create]
    end
    
  end

  root 'pages#start'  # Set the start page as the root
  
  get 'my_quizzes', to: 'quizzes#my_quizzes'
  get 'highscores', to: 'highscores#index'
  get 'profile', to: 'users#profile', as: 'user_profile'
end
