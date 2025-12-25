class BoardgameMessagesController < ApplicationController
  def new
    @boardgame = Boardgame.find(params[:boardgame_id])
    @contact_message = ContactMessage.new()
  end

  def create
    @boardgame = Boardgame.find(params[:boardgame_id])
    @contact_message = ContactMessage.new(contact_message_params.merge(
      subject: :error_report,
      user_agent: request.user_agent,
      contactable: @boardgame
    ))

    if @contact_message.save
      redirect_to @boardgame, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:body)
  end
end
