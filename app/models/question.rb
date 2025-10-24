class Question < ApplicationRecord
  belongs_to :survey
  has_many :responses, dependent: :destroy
  has_many :question_role_targets, dependent: :delete_all
  has_many :target_roles, through: :question_role_targets, source: :role
  
  validates :content, presence: true
  validates :question_type, presence: true
  
  # Define question types
  QUESTION_TYPES = ['text', 'long_text', 'multiple_choice', 'checkbox', 'rating'].freeze
  
  # Ensure position is maintained within a survey
  acts_as_list scope: :survey
  
  # Serialize options as an array
  serialize :options, Array
  
  # Ensure options are present for question types that need them
  validate :validate_options_for_question_type
  
  private
  
  def validate_options_for_question_type
    if ['multiple_choice', 'checkbox'].include?(question_type) && (options.nil? || options.empty?)
      errors.add(:options, "can't be blank for #{question_type} questions")
    end
  end

  def visible_to_roles?(role_ids)
    target_roles.empty? || target_roles.exists?(id: role_ids)
  end
end
