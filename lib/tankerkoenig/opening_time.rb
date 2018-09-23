module Tankerkoenig
  class OpeningTime
    attr_reader :text, :start, :end

    def initialize(attributes)
      @text = attributes[:text]
      @start = attributes[:start]
      @end = attributes[:end]
    end
  end
end
