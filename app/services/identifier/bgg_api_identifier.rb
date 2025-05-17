module Identifier
  class BggApiIdentifier < Base
    private

    def failed_flag
      :failed_bgg_api_identification
    end

    def search_method_class
      SearchMethod::BggApiSearch
    end
  end
end
