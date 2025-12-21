module Text
  module Normalization
    class << self
      def normalize_string(string)
        string.strip
              .downcase
              .unicode_normalize(:nfkd)
              .gsub(/[^a-z0-9 ]/, "")
              .squeeze(" ")
      end

      def normalize_title(string)
        normalize_string(string).gsub(/ (espanol|ingles)\s*$/, "")
      end

      def search_value(string)
        return "" if string.blank?

        I18n.transliterate(string).downcase
      end
    end
  end
end
