class Submission < ApplicationRecord
  belongs_to :survey
  belongs_to :role, optional: true
  has_many :responses, dependent: :destroy
end