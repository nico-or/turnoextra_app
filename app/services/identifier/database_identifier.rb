module Identifier
  class DatabaseIdentifier < Base
    private

    def failed_flag
      :failed_local_identification
    end

    def search_method_class
      SearchMethod::DatabaseSearch
    end
  end
end
