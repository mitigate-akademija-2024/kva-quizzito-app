class AddDraftToUserAnswers < ActiveRecord::Migration[7.1]
  def change
    add_column :user_answers, :draft, :boolean
  end
end
