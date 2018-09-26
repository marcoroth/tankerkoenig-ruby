require 'faraday'
require 'json'

module Tankerkoenig
  class Station
    attr_reader :id, :name, :brand, :street, :house_number, :post_code, :place
    attr_reader :price, :opening_times, :overrides, :whole_day, :is_open
    attr_reader :lat, :lng, :state

    def initialize(station)
      return if station.nil?

      @id = station[:id]
      @name = station[:name]
      @brand = station[:brand]
      @street = station[:street]
      @house_humber = station[:houseNumber]
      @post_code = station[:postCode]
      @place = station[:place]
      @opening_times = []
      @overrides = station[:overrides]
      @whole_day = station[:wholeDay]
      @is_open = station[:isOpen]
      @lat = station[:lat]
      @lng = station[:lng]
      @state = station[:state]
      @price = Price.new(@id, station[:e5], station[:e10], station[:diesel], @is_open)

      open_times = station[:openingTimes] || []

      open_times.each do |opening_time|
        @opening_times << OpeningTime.new(opening_time)
      end
    end

    def self.detail(id)
      return Response.new(message: 'you have to submit a valid station id') if id.nil? || id.empty?

      response = conn.get('detail.php', id: id)
      attributes = JSON.parse(response.body, symbolize_names: true)
      response = Response.new(attributes)
      response.result = Station.new(attributes[:station])
      response
    end

    def self.list(lat: nil, lng: nil, rad: 1, type: nil, sort: nil)
      type_options = %w[e5 e10 diesel all]
      sort_options = %w[price dist]

      return Response.new(message: 'you need to submit a valid lat coordinate') if lat.nil?
      return Response.new(message: 'you need to submit a valid lng coordinate') if lng.nil?
      return Response.new(message: 'you need to submit a valid radius between 1 and 25') if rad.nil? || rad.to_f >= 25 || rad.to_f < 1

      if sort.nil? && type.nil?
        type = :all
      else
        return Response.new(message: "wrong type parameter. The available options are #{type_options}") unless type_options.include?(type.to_s)
      end

      return Response.new(message: "wrong sort parameter. The available options are #{sort_options}") unless sort_options.include?(sort.to_s)

      response = conn.get('list.php', lat: lat, lng: lng, rad: rad, type: type, sort: sort)
      attributes = JSON.parse(response.body, symbolize_names: true)
      response = Response.new(attributes)
      response.result = []

      if response.success?
        attributes[:stations].each do |station|
          response.result << Station.new(station)
        end
      end

      response
    end

    def self.conn
      Tankerkoenig.conn
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
