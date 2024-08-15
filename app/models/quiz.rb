class Quiz < ApplicationRecord

  belongs_to :user

  validates :title, presence: true, uniqueness: true
  validates :user, presence: true
  
  before_validation :normalize_title
  before_save :normalize_description


  has_many :scores, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :user_scores, class_name: 'Score', dependent: :destroy
  has_many :feedbacks, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

 
  protected

  def normalize_title
    Rails.logger.info("Quiz#normalize_title called")
    self.title = title.to_s.squish.capitalize
  end

  def normalize_description
    Rails.logger.info("Quiz#normalize_description called")
    self.description = description.to_s.squish
  end
end