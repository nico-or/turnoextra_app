class ContactMessage < ApplicationRecord
  enum :archived_status, { active: 0, archived: 1 }, default: :active, validate: true
  enum     :read_status, { unread: 0,     read: 1 }, default: :unread, validate: true
  enum     :spam_status, {  legit: 0,     spam: 1 }, default:  :legit, validate: true
  enum :status,  { pending: 0, addressed: 1, dismissed: 2  },     default: :pending, validate: true
  enum :subject, { general: 0, suggestion: 1, error_report: 2 },  default: :general, validate: true

  belongs_to :contactable, polymorphic: true, optional: true

  validates :body, presence: true
  validates :user_agent, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  before_validation :format_email

  def mark_addressed!
    addressed!
    archived!
  end

  def mark_spam!
    spam!
    dismissed!
    archived!
  end

  def reset_status!
    unread!
    legit!
    pending!
    active!
  end

  private

  def format_email
    self.email = email.downcase.strip if email.present?
  end
end
