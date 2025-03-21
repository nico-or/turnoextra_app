class SearchController < ApplicationController
  def search
    @query = params[:q]
  end
end
