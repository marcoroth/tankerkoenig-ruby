require "tankerkoenig/version"
require "tankerkoenig/response"
require "tankerkoenig/station"
require "tankerkoenig/price"
require "tankerkoenig/opening_time"

module Tankerkoenig
	@api_base = 'https://creativecommons.tankerkoenig.de/json'
	@api_key = ''

	class << self
		attr_accessor :api_key, :api_base
	end
end
