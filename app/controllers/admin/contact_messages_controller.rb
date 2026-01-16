class Admin::ContactMessagesController < AdminController
  def index
    @contact_messages = ContactMessage.all.order(created_at: :desc)
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
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
end
