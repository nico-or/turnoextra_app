class Admin::ContactMessagesController < AdminController
  def index
    @contact_messages = ContactMessage.all.order(created_at: :desc)
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
    @contact_message.update(read: true) unless @contact_message.read?
  end

  def toggle_read
    @contact_message = ContactMessage.find(params[:id])

    if @contact_message.read?
      @contact_message.update!(read: false)
      flash[:notice] = "Marked as unread."
    else
      @contact_message.update!(read: true)
      flash[:notice] = "Marked as read."
    end

    redirect_to admin_contact_message_path(@contact_message)
  end

  def mark_addressed
     @contact_message = ContactMessage.find(params[:id])
     @contact_message.update(status: :addressed, archived: true)
     redirect_to admin_contact_message_path(@contact_message)
  end

  def mark_spam
    @contact_message = ContactMessage.find(params[:id])
    @contact_message.update(status: :dismissed, archived: true, spam: true)
    redirect_to admin_contact_message_path(@contact_message)
  end

  def reset_status
    @contact_message = ContactMessage.find(params[:id])
    @contact_message.update(status: :pending, spam: false, archived: false, read: false)
    redirect_to admin_contact_message_path(@contact_message)
  end
end
