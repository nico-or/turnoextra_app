module Reports
  module StorePrices
    class StoreRow
      attr_reader :store

      def initialize(store, records)
        @store = store
        @records = records
      end

      def store_id
        store.id
      end

      def store_url
        store.url
      end

      def cell_for(date)
        count_cells.find { |r| r.date == date } || NullCountCell.new
      end

      private

      attr_reader :records

      def count_cells
        @count_cells ||= records.map do |record|
          CountCell.new(
            count: record.price_count,
            date: record.date,
            store_mean: mean,
            store_std_dev: std_dev
          )
        end
      end

      def mean
        return if records.empty?

        @mean ||= records.sum(&:price_count).fdiv(records.length)
      end

      def std_dev
        return if records.empty?
        return 0 if records.length < 2

        @std_dev ||=
          Math.sqrt(std_dev_factor * mean_squared_error)
      end

      def std_dev_factor
        1.fdiv(records.length - 1)
      end

      def mean_squared_error
        records.sum { |record| (record.price_count - mean) ** 2 }
      end
    end
  end
end
