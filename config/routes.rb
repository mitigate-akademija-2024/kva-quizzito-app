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

    post 'submit_feedback', on: :member

    member do
      get 'take'      # Route for taking the quiz
      post 'submit_results', to: 'quizzes#submit_results'
      get 'results'   # Route for viewing quiz results
      get 'highscores', to: 'highscores#quiz_highscores'
      get 'export_highscores_csv', to: 'highscores#export_highscores_csv'
      get 'finished', to: 'quizzes#quiz_finished', as: 'quiz_finished'
      get 'confirm_delete', to: 'quizzes#confirm_delete', as: 'confirm_delete' 
      post 'submit_feedback', to: 'quizzes#submit_feedback'      

    end

    collection do
      get 'search', to: 'quizzes#search'
    end
    
    resources :questions do
      resources :user_answers, only: [:create]
    end

    resources :feedbacks, only: [:create]
    
  end

  resources :highscores, only: [:index] do
    collection do
      get :export_csv
    end
  end

  root 'pages#start'  # Set the start page as the root
  
  get 'my_quizzes', to: 'quizzes#my_quizzes'
  get 'highscores', to: 'highscores#index'
  get 'profile', to: 'users#profile', as: 'user_profile'
  get 'my_feedbacks', to: 'feedbacks#index', as: 'my_feedbacks'
  get 'highscores', to: 'highscores#quiz_highscores', as: 'quiz_highscores'

end
