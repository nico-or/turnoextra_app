class ContactMessagesController < ApplicationController
  skip_before_action :authorize_user, only: [ :new, :create ]
  rate_limit to: 5, within: 1.minute, with: -> { redirect_to contact_path, alert: "Rate limit exceeded. Please try again later." }, only: [ :create ]

  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params.merge(user_agent: request.user_agent))
    if @contact_message.save
      flash[:notice] = @contact_message.email? ? t(".success.contact") : t(".success.annonymous")
      redirect_to contact_path
    else
      flash[:alert] = t(".failure")
      render :new
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :body)
  end
end
