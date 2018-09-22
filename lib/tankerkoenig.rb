require "tankerkoenig/version"
require "tankerkoenig/response"
require "tankerkoenig/station"
require "tankerkoenig/price"
require "tankerkoenig/opening_time"

module Tankerkoenig
  @api_base = 'https://creativecommons.tankerkoenig.de/json'
  @api_key = ENV['TANKERKOENIG_API_KEY'] || ''

  class << self
    attr_accessor :api_key, :api_base
  end

  def self.conn
    if defined?(@conn)
      @conn
    else
      @conn = Faraday.new(@api_base) do |faraday|
        faraday.params['apikey'] = @api_key
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  def self.conn=(conn)
    @conn = conn
  end

end
