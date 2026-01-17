module Admin
  class ReportsController < AdminController
    def store_prices_count
      @dates = time_period.sort
      @price_data = Store.left_joins(listings: [ :prices ])
        .select(:id, "stores.id as store_id", "prices.date", "COUNT(*) as price_count")
        .group("stores.id", "prices.date")
        .where(prices: { date: time_period })
        .order("price_count DESC")

      store_data = Store.select(:id, :url).index_by(&:id)

      @store_rows =
        @price_data.group_by(&:store_id).map do |(store_id, records)|
          Reports::StorePrices::StoreRow.new(store_data[store_id], records)
        end
    end

    private

    def time_period
      Price.latest_update_date-7..Price.latest_update_date
    end
  end
end
