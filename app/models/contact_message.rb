class ContactMessage < ApplicationRecord
  attribute :archived, :boolean, default: false
  attribute :read,     :boolean, default: false
  attribute :spam,     :boolean, default: false

  enum :status,  { pending: 0, addressed: 1, dismissed: 2  },     default: :pending, validate: true
  enum :subject, { general: 0, suggestion: 1, error_report: 2 },  default: :general, validate: true

  belongs_to :contactable, polymorphic: true, optional: true

  validates :body, presence: true
  validates :user_agent, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  before_validation :format_email

  private

  def format_email
    self.email = email.downcase.strip if email.present?
  end
end
