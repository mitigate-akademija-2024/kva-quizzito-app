class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[7.1]
  def change
    # Remove existing foreign key constraints
    remove_foreign_key :questions, :quizzes
    remove_foreign_key :answers, :questions
    remove_foreign_key :scores, :quizzes

    # Add new foreign key constraints with ON DELETE CASCADE
    add_foreign_key :questions, :quizzes, on_delete: :cascade
    add_foreign_key :answers, :questions, on_delete: :cascade
    add_foreign_key :scores, :quizzes, on_delete: :cascade
  end
end
