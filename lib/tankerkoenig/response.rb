module Tankerkoenig
  class Response
    attr_reader :ok, :license, :data, :status, :message
    attr_accessor :result

    def initialize(attributes)
      @ok = !attributes[:ok].nil? ? attributes[:ok] : false
      @license = attributes[:license] || ''
      @data = attributes[:data] || ''
      @status = attributes[:status] || ''
      if @ok
        @message = attributes[:message] || ''
      else
        @message = attributes[:message] || 'an error occured'
      end
      @result = []
    end

    def success?
      @ok
    end

    def error?
      !@ok
    end

    def any?
      @result != [] && @result != nil
    end

  end
end
