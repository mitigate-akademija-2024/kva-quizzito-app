class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :question_text, null: false
      t.timestamps
      t.references :questions
    end
  end
end
