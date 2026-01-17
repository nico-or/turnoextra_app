module Reports
  module StorePrices
    # Represents a single cell in the StorePricesCount report table.
    # It stores the count and relevant state to calculate it's CSS class.
    class CountCell
      attr_reader :count, :date, :store_mean, :store_std_dev

      def initialize(count:, date:, store_mean:, store_std_dev:)
        @count  = count
        @date = date
        @store_mean = store_mean
        @store_std_dev = store_std_dev
      end

      # The CSS class is calculated based on statistical control ranges.
      def class
        case z_score
        # After some testing, 1.5 std-devs was too noisy
        when 2..Float::INFINITY
          "table-warning"
        else
          nil
        end
      end

      private

      def z_score
        # If the store has the same prices every date, is considered under control.
        return 0 if store_std_dev.zero?

        (count - store_mean).abs.fdiv(store_std_dev)
      end
    end
  end
end
