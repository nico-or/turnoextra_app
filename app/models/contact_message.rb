class ContactMessage < ApplicationRecord
  attribute :archived, :boolean, default: false
  attribute :read,     :boolean, default: false
  attribute :spam,     :boolean, default: false

  enum :status, { unread: 0, read: 1, responded: 2  }
  enum :subject, { general: 0, suggestion: 1, error_report: 2 }

  belongs_to :contactable, polymorphic: true, optional: true

  validates :body, presence: true
  validates :user_agent, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :status, presence: true, inclusion: { in: ContactMessage.statuses.keys }
  validates :subject, presence: true,  inclusion: { in: ContactMessage.subjects.keys }

  before_validation :format_email

  private

  def format_email
    self.email = email.downcase.strip if email.present?
  end
end
