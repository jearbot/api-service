# To preface this, I know this is might not be the most practical way to implement this
# But for lack of complexity I just went with a service instead of repeating these methods on each model
# My thoughts here on how to reduce API calls would be:
	# We soft delete records, since I have indexes on the driver and ride for unique addresses,
	# we would do some sort of scan when creating new drivers/rides to re-use the coordinates since the coordinates should be pretty static based on address.
	# There is also a frige case where maybe a driver is living in an apartment, and we wouldn't have to make the same call to get the coordinates since technically the addresses would be unique (because of apartment numbers) but the street address would be the same.
	# Also another super fringe case of a driver moving out of a home, and another one moved in.
	# But I would think at least the destination address would be reused quite frequently.
	# Also I had thought maybe we could just make an address model that doesn't necessarily associate with any driver/ride
	# and store the addresses and coordinates, and do a scan of that table prior to geocoding to see if there is a match and just re-use it.
	# That does technically depending on having an exact match of address, where as some people might put it differently
	# E.G. (108 tangled brush dr VS 108 tangled brush drive), but if you maybe used another less expensive auto-complete service that might not be such an issue

	class GeocoderService
		require 'cgi'

		BASE_URL = 'https://api.openrouteservice.org'
		DIRECTIONS = '/v2/directions/driving-car'
		START = '&start='
		FINISH = '&end='
		SEARCH = '/geocode/search?api_key='
		TEXT = "&text="
	
		def self.geocode_address(object, attribute, address)
			headers = {
				"accept" => 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8'
			}

			response = HTTParty.get(
				"#{BASE_URL}#{SEARCH}#{ENV['OPENROUTE_TOKEN']}#{TEXT}#{CGI.escape(address)}",
				headers: headers
			)
	
			# could set this up in sidekiq to retry if say there was a failure
			if response.success?
				coordinates = response.deep_symbolize_keys[:features][0][:geometry][:coordinates]
				object.update("#{attribute}": coordinates)
			end
		end
	
		def self.calculate_route(object, home, start, finish)
			body = { coordinates: [home, start, finish], units: 'mi' }.to_json

			headers = {
				"accept" => 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
				"Authorization" => ENV['OPENROUTE_TOKEN'],
				"Content-Type" => 'application/json; charset=utf-8'
			}
	
			response = HTTParty.post(
				"#{BASE_URL}#{DIRECTIONS}",
				headers: headers,
				body: body
			)
	
			# same here, could set this up in sidekiq to retry if say there was a failure
			if response.success?
				response = response.deep_symbolize_keys
				commute_distance = response[:routes][0][:segments][0][:distance]
				commute_duration = response[:routes][0][:segments][0][:duration]
				# duration is stored in seconds
				ride_distance = response[:routes][0][:segments][1][:distance]
				ride_duration = response[:routes][0][:segments][1][:duration]
				# duration is stored in seconds
	
				object.update(
					commute_distance: commute_distance,
					commute_duration: commute_duration,
					ride_distance: ride_distance,
					ride_duration: ride_duration,
				)
			end
		end
	end
