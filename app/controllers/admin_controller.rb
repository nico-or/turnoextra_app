class AdminController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless Current.user&.admin?
      redirect_to login_path, alert: "unauthorized."
    end
  end
end
