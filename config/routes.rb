Rails.application.routes.draw do
  
  get 'pages/start'
  devise_for :users
  

  resources :quizzes do
    resources :questions do
      resources :answers
    end
    post 'submit_answers', on: :member
    get 'review', on: :member
    get 'results', on: :member
    delete 'reset_answers', on: :member 
  end

  root 'pages#start'  # Set the start page as the root
  
  get 'my_quizzes', to: 'quizzes#my_quizzes'

  get 'highscores', to: 'highscores#index' 
  resources :quizzes
  
  get 'my_quizzes', to: 'quizzes#my_quizzes'
  
end