module Tankerkoenig
  class Response
    attr_reader :ok, :license, :data, :status, :message
    attr_accessor :result

    def initialize(attributes)
      @ok = attributes['ok']
      @license = attributes['license']
      @data = attributes['data']
      @status = attributes['status']
      @message = attributes['message']
      @result = []
    end

    def success?
      @ok
    end

    def error?
      !@ok
    end
  end
end
