class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  belongs_to :role, optional: true
  validates :value, presence: true
  belongs_to :submission, optional: true
end
