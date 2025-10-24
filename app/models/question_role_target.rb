class QuestionRoleTarget < ApplicationRecord
  belongs_to :question
  belongs_to :role
  validates :role_id, uniqueness: { scope: :question_id }
end