require 'faraday'
require 'json'

module Tankerkoenig
  class Station
    attr_reader :id, :name, :brand, :street, :house_number, :post_code, :place
    attr_reader :price, :opening_times, :overrides, :whole_day, :is_open
    attr_reader :lat, :lng, :state

    def initialize(station)
      @id = station['id']
      @name = station['name']
      @brand = station['brand']
      @street = station['street']
      @house_humber = station['houseNumber']
      @post_code = station['postCode']
      @place = station['place']
      @opening_times = []
      @overrides = station['overrides']
      @whole_day = station['wholeDay']
      @is_open = station['isOpen']
      @lat = station['lat']
      @lng = station['lng']
      @state = station['state']
      @price = Price.new(@id, station['e5'], station['e10'], station['diesel'], @is_open)

      open_times = station['openingTimes'] || []

      open_times.each do |opening_time|
        @opening_times << OpeningTime.new(opening_time)
      end
    end

    def self.detail(id)
      url = "#{Tankerkoenig.api_base}/detail.php?id=#{id}&apikey=#{Tankerkoenig.api_key}"
      response = Faraday.get(url)
      attributes = JSON.parse(response.body)
      response = Response.new(attributes)
      response.result = Station.new(attributes)
      response
    end


    def self.list(lat, lng, rad, type, sort)
      url = "#{Tankerkoenig.api_base}/list.php?lat=#{lat}&lng=#{lng}&rad=#{rad}&type=#{type}&sort=#{sort}&apikey=#{Tankerkoenig.api_key}"
      response = Faraday.get(url)
      attributes = JSON.parse(response.body)
      response = Response.new(attributes)

      stations = []

      if response.success?
        attributes['stations'].each do |station|
          stations << Station.new(station)
        end
      end

      response.result = stations
      response
    end

    def detail
      Station.detail(@id).result
    end

    def open?
      @is_open
    end

    def closed?
      !@is_open
    end

    def whole_day?
      @whole_day
    end

    def e5
      @price.e5
    end

    def e10
      @price.e10
    end

    def diesel
      @price.diesel
    end

    def e5?
      !e5.nil? && e5.class == Float
    end

    def e10?
      !e10.nil? && e10.class == Float
    end

    def diesel?
      !diesel.nil? && diesel.class == Float
    end
  end
end
