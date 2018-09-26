require 'faraday'
require 'json'

module Tankerkoenig
  class Price
    attr_reader :station_id, :status, :e5, :e10, :diesel

    def initialize(*attributes)
      if attributes.count == 2
        @station_id = attributes[0]
        @status = attributes[1][:status]
        @e5 = attributes[1][:e5]
        @e10 = attributes[1][:e10]
        @diesel = attributes[1][:diesel]
      end

      if attributes.count == 5
        @station_id = attributes[0]
        @e5 = attributes[1]
        @e10 = attributes[2]
        @diesel = attributes[3]
        @status = attributes[4] ? 'open' : 'closed'
      end
    end

    def self.get(ids)
      ids = ids.join(',') if ids.is_a?(Array)
      return Response.new(message: 'ids must be an Array or a String') unless ids.is_a?(String)

      response = conn.get('prices.php', ids: ids)
      attributes = JSON.parse(response.body, symbolize_names: true)
      response = Response.new(attributes)
      response.result = []

      if response.success?
        attributes['prices'].to_a.each do |p|
          response.result << new(p.first, p.last)
        end
      end

      response
    end

    def self.conn
      Tankerkoenig.conn
    end

    def station
      Station.detail(@station_id).result
    end

    def open?
      @status == 'open'
    end

    def closed?
      @status == 'closed'
    end

    def prices?
      @status != 'no prices' && !@e5.nil? && !@e10.nil? && !@diesel.nil?
    end

    def e5?
      @e5 != false
    end

    def e10?
      @e10 != false
    end

    def diesel?
      @diesel != false
    end
  end
end
