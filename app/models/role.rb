class Role < ApplicationRecord
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  before_validation :ensure_slug

  has_many :question_role_targets, dependent: :delete_all
  has_many :targeted_questions, through: :question_role_targets, source: :question

  def to_param
    slug.presence || super
  end

  private

  def ensure_slug
    self.slug = (slug.presence || role.to_s).parameterize if role.present? || slug.present?
  end
end