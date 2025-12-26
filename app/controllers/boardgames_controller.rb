class BoardgamesController < ApplicationController
  def index
    boardgames = BoardgameDeal
      .with_boardgame_card_data
      .order(:title)

    @pagy, @boardgames = pagy(boardgames, limit: 12)
  end

  def show
    # TODO: do we need both objects?
    @boardgame = Boardgame.find(params[:id])
    @boardgame_deal = @boardgame.boardgame_deal

    @reference_price = @boardgame_deal&.m_price

    if params[:slug] != @boardgame_deal&.slug
      redirect_to slugged_boardgame_path(@boardgame, slug: @boardgame_deal&.slug),
        status: :moved_permanently
    end

    Impression.impression_for(@boardgame, visitor: Current.visitor)

    @listings = Boardgames::AvailableListings.new(@boardgame).data
    @chart_data = Boardgames::PricePlotData.new(@boardgame).data
  end
end
