class UserScore < ApplicationRecord
  self.table_name = 'scores'
  belongs_to :user
  belongs_to :quiz
end