Rails.application.routes.draw do
  get 'users/profile'
  get 'pages/start'

  get 'feedback_submitted', to: 'feedbacks#feedback_submitted'

  devise_for :users, skip: :sessions
  as :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    post 'sign_in', to: 'devise/sessions#create', as: :user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :quizzes do
    member do
      get 'take'
      post 'submit_results'
      get 'results'
      get 'quiz_highscores', to: 'highscores#quiz_highscores'  # Moved to highscores controller
      get 'export_highscores_csv', to: 'highscores#export_quiz_highscores_csv'  # Moved to highscores controller
      get 'finished', to: 'quizzes#quiz_finished', as: 'quiz_finished'
      get 'confirm_delete'
      post 'submit_feedback'
      post 'submit_answers'
    end

    collection do
      get 'search'
    end

    resources :questions do
      resources :user_answers, only: [:create]
    end

    resources :feedbacks, only: [:create]
  end

  resources :highscores, only: [:index] do
    collection do
      get 'export_csv'
    end

    member do
      get 'quiz_highscores'
      get 'export_quiz_highscores_csv'
    end
  end

  root 'pages#start'

  get 'my_quizzes', to: 'quizzes#my_quizzes'
  get 'profile', to: 'users#profile', as: 'user_profile'
  get 'my_feedbacks', to: 'feedbacks#index', as: 'my_feedbacks'
end
