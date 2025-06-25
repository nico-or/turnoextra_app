class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # https://github.com/rails/rails/blob/main/actionpack/lib/action_controller/metal/allow_browser.rb
  # Allow safari >= 16 due to user request.
  # We aren't using any 'modern' browser features, so it should be ok (?)
  allow_browser versions: { safari: 16, chrome: 120, firefox: 121, opera: 106, ie: false } if Rails.env.production?

  before_action :set_current_user

  include Pagy::Backend

  protected

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
