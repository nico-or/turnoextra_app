class StoresController < ApplicationController
  skip_before_action :authorize_user, only: %i[index]

  def index
    @stores = Store.all
  end
end
