class SessionsController < ApplicationController
  skip_before_action :authorize_user, only: %i[new create]

  def new
  end

  def create
    if @user = User.authenticate_by(login_params)
      login(@user)
      redirect_to root_path, notice: "logged in"
    else
      flash.alert = "invalid credetials"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "logged out"
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def login(user)
    reset_session
    session[:user_id] = user.id
    Current.user = user
  end

  def logout
    reset_session
    Current.user = nil
  end
end
