class BoardgamePriceUpdateService
  attr_reader :boardgame, :reference_date, :time_window

  def initialize(boardgame, reference_date = Price.latest_update_date, time_window = 2.weeks)
    @boardgame = boardgame
    @reference_date = reference_date
    @time_window = time_window
  end

  def call
    best_price = boardgame.prices.select { |p| p.date == reference_date }.map(&:amount).min
    prices = boardgame.prices.select { |p| reference_period.include?(p.date) }.map(&:amount).sort
    return if prices.empty?

    reference_price = case (prices.length % 2)
    when 0
      (prices[prices.length / 2 - 1] + prices[prices.length / 2]) / 2
    when 1
      prices[prices.length / 2]
    end

    discount = if reference_price.present? && best_price.present?
      discount_value = ((1 - (best_price / reference_price.to_f))*100).to_i
      discount_value.negative? ? 0 : discount_value
    end

    boardgame.update(best_price: best_price, reference_price: reference_price, discount: discount)
  end

  private

  def reference_period
    ((reference_date - time_window)..(reference_date))
  end
end
