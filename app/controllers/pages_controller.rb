class PagesController < ApplicationController
  skip_before_action :authorize_user
end
