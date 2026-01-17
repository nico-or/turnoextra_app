class Admin::ContactMessagesController < AdminController
  before_action :set_contact_message, except: [ :index ]
  def index
    @contact_messages = ContactMessage.all.order(created_at: :desc)
  end

  def show
    @contact_message.update(read: true) unless @contact_message.read?
  end

  def mark_addressed
     @contact_message.update(status: :addressed, archived: true)
     redirect_to admin_contact_message_path(@contact_message)
  end

  def mark_spam
    @contact_message.update(status: :dismissed, archived: true, spam: true)
    redirect_to admin_contact_message_path(@contact_message)
  end

  def reset_status
    @contact_message.update(status: :pending, spam: false, archived: false, read: false)
    redirect_to admin_contact_message_path(@contact_message)
  end

  private

  def set_contact_message
    @contact_message = ContactMessage.find(params[:id])
  end
end
