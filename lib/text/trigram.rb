module Text
  module Trigram
    class << self
      def similarity(str1, str2)
        trgm_1 = generate_trigrams(str1)
        trgm_2 = generate_trigrams(str2)

        all_trgm = (trgm_1 | trgm_2)
        common_trgm = (trgm_1 & trgm_2)

        return 0.0 if all_trgm.empty?

        common_trgm.size.to_f / all_trgm.size
      end

      private

      # Helper method to generate trigrams from a string
      #   This method adds two spaces at the beginning and one space at the end of the string
      #   to give more weight to the start of the string
      def generate_trigrams(string)
        normalized_string = Text::Normalization.normalize_string(string)
        "  #{normalized_string} ".chars.each_cons(3).map(&:join)
      end
    end
  end
end
