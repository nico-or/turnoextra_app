class Admin::ContactMessagesController < AdminController
  before_action :set_contact_message, except: [ :index ]
  def index
    @contact_messages = ContactMessage
    .where(spam: false, archived: false)
    .order(created_at: :desc)
  end

  def show
    @contact_message.read!
  end

  def mark_addressed
     @contact_message.mark_addressed!
     redirect_to admin_contact_message_path(@contact_message)
  end

  def mark_spam
    @contact_message.mark_spam!
    redirect_to admin_contact_message_path(@contact_message)
  end

  def reset_status
    @contact_message.reset_status!
    redirect_to admin_contact_message_path(@contact_message)
  end

  private

  def set_contact_message
    @contact_message = ContactMessage.find(params[:id])
  end
end
