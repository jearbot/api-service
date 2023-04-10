FactoryBot.define do
	factory :ride do
		external_id { "R-#{Faker::Alphanumeric.alphanumeric(number: 10).upcase}" }
		start_address { Faker::Address.full_address }
		start_coordinates { [Faker::Address.longitude, Faker::Address.latitude] }
		destination_address { Faker::Address.full_address }
		destination_coordinates { [Faker::Address.longitude, Faker::Address.latitude] }
		driver
		commute_distance { Faker::Number.between(from: 1, to: 100) }
		commute_duration { Faker::Number.between(from: 1, to: 10000) }
		ride_distance { Faker::Number.between(from: 1, to: 50) }
		ride_duration { Faker::Number.between(from: 1, to: 10000) }

		after(:create, :build) do |ride|
			ride.class.set_callback(:create, :after, :geocode_address)
			ride.class.set_callback(:create, :after, :calculate_route)
			ride.class.skip_callback(:create, :after, :geocode_address)
			ride.class.skip_callback(:create, :after, :calculate_route)
		end

		factory :ride_with_callbacks do
			after(:create, :build) do |ride|
					ride.send(:geocode_address)
					ride.send(:calculate_route)
			end
		end
	end
end