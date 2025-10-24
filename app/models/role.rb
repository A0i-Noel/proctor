class Role < ApplicationRecord
  # Associations
  has_many :question_role_targets, dependent: :delete_all
  has_many :targeted_questions, through: :question_role_targets, source: :question
  has_many :submissions
  has_many :responses

  # Soft delete scopes
  scope :alive, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :including_deleted, -> { all }

  # Validations
  validates :role,
    presence: true,
    uniqueness: { case_sensitive: false, conditions: -> { where(deleted_at: nil) } }

  validates :slug,
    presence: true,
    uniqueness: { conditions: -> { where(deleted_at: nil) } },
    format:   { with: /\A[a-z0-9-]+\z/ }

  # Slug
  before_validation :ensure_slug

  def to_param
    slug.presence || super
  end

  # Soft delete / restore
  def destroy
      transaction do
        # remove targeting rows so the role stops being “targeted” anywhere
        question_role_targets.delete_all
        update!(deleted_at: Time.current)
      end
  end

    def restore!
      update!(deleted_at: nil)
    end
    
  private

  def ensure_slug
    base = slug.presence || role.to_s
    self.slug = base.parameterize if base.present?
  end
end
