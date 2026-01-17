module Admin
  class ReportsController < AdminController
    def store_prices_count
      price_data = Store.left_joins(listings: [ :prices ])
        .select(:id, "prices.date", "COUNT(*) as price_count")
        .group("stores.id", "prices.date")
        .where(prices: { date: time_period })
        .order("price_count DESC", "id")

      @price_hash = Hash.new { |h, k| h[k] = {} }
      @dates = Set.new

      price_data.each do |result|
        @price_hash[result.id][result.date] = result.price_count
        @dates << result.date
      end

      @store_hash = Store.select(:id, :url).index_by(&:id)

      price_data_by_store = price_data.group_by(&:id)

      @count_hash = price_data_by_store.each_with_object({}) do |(store_id, counts), hash|
        sum = counts.sum(&:price_count)
        mean = sum.to_f / counts.size

        hash[store_id] = {
          mean: mean,
          stdev: Math.sqrt(counts.sum { |store| (store.price_count - mean) ** 2 })
        }
      end
    end

    private

    def time_period
      Price.latest_update_date-7..Price.latest_update_date
    end
  end
end
