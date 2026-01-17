module Reports
  module StorePrices
    # NullObject for a CountCell
    # Created when a store has no prices for a date.
    class NullCountCell
      def count
        0
      end

      def class
        "table-danger"
      end
    end
  end
end
