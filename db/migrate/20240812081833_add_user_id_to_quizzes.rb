class AddUserIdToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :user_id, :integer
  end
end
