class ContactMessagesController < ApplicationController
  skip_before_action :authorize_user, only: [ :new, :create, :new_boardgame_error, :create_boardgame_error ]
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

  def new_boardgame_error
    @contact_message = ContactMessage.new(subject: :error_report)
    @boardgame = Boardgame.find(params[:boardgame_id])
  end

  def create_boardgame_error
    @boardgame = Boardgame.find_by(id: params[:boardgame_id])
    @contact_message = ContactMessage.new(subject: :error_report, user_agent: request.user_agent)
    @contact_message.body = <<~MSG
      boardgame_id: #{@boardgame.id}
      boardgame_title: #{@boardgame.title}
      boardgame_url: #{boardgame_url(@boardgame)}

      ---

      #{params[:contact_message][:body]}
    MSG

    if @contact_message.save
      redirect_to boardgame_path(@boardgame), notice: t(".success")
    else
      render :new_boardgame_error, alert: t(".failure")
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :body)
  end
end
