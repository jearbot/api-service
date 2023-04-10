require 'rails_helper'

describe Ride, type: :model do
	let(:driver) { create(:driver) }

	describe 'associations' do
		it { should belong_to(:driver) }
	end

	describe 'validations' do
		subject { create(:ride, driver: driver) }

		it { is_expected.to validate_uniqueness_of(:external_id) }
	end

	describe 'callbacks' do
		let(:ride) { build(:ride_with_callbacks, driver: driver) }

		subject { ride.save }

		it 'geocodes start and destination addresses and calculates route' do
			expect_any_instance_of(Ride).to receive(:geocode_address).once
			expect_any_instance_of(Ride).to receive(:calculate_route).once
			subject
		end
	end

	describe 'methods' do
		let(:ride) { build_stubbed(:ride) }

		describe '#calculate_earnings' do
			it 'calculates earnings correctly' do
				# Set ride_duration and ride_distance
				ride.ride_duration = 1000 # 100 additional seconds
				ride.ride_distance = 6 # 1 additional mile

				expected_earnings = Ride::BASE_PAY + (1 * Ride::MILE_RATE) + ((100 / 60.0) * Ride::MINUTE_RATE)
				expect(ride.send(:calculate_earnings)).to eq(expected_earnings)
			end
		end

		describe '#calculate_score' do
			it 'calculates score correctly' do
				# Set earnings, commute_duration, and ride_duration
				ride.earnings = 25
				ride.commute_duration = 1200 # 20 minutes
				ride.ride_duration = 1000 # 16.67 minutes
				expected_score = (ride.earnings / (ride.commute_duration + ride.ride_duration))
				expect(ride.send(:calculate_score, ride.earnings)).to eq(expected_score)
			end
		end

		describe '#geocode_address' do
			it 'calls geocoder service' do
				expect(GeocoderService).to receive(:geocode_address).with(
						ride,
						'start_coordinates',
						ride.start_address
				).once
				expect(GeocoderService).to receive(:geocode_address).with(
						ride,
						'destination_coordinates',
						ride.destination_address
				).once
				ride.send(:geocode_address)
			end
		end

		describe '#calculate_route' do
			it 'calls geocoder service' do
				expect(GeocoderService).to receive(:calculate_route).with(
						ride,
						ride.driver.home_coordinates,
						ride.start_coordinates,
						ride.destination_coordinates
				).once
				ride.send(:calculate_route)
			end
		end
	end
end