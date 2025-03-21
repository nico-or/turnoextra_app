module Bgg
  class NokogiriParser < HTTParty::Parser
    def parse
      Nokogiri::XML(@body) do |config|
        config.noblanks
      end
    end
  end
end
