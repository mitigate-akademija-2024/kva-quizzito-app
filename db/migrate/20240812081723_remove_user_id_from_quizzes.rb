class RemoveUserIdFromQuizzes < ActiveRecord::Migration[7.1]
  def change
    remove_column :quizzes, :user_id, :integer
  end
end
