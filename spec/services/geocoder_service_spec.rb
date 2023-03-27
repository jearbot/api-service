require 'rails_helper'

describe GeocoderService do
	let(:driver) { create(:driver) }
	let(:party_double) { double(HTTParty) }

	describe '#geocode_address' do
		let(:coordinates) { [-77.0365556, 38.8976757] }
		let(:response) do
			{ features: [ { geometry: { coordinates: coordinates } } ] }
		end

		context 'when geocoding is successful' do
			before do
				allow(HTTParty).to receive(:get).and_return(party_double)
				allow(party_double).to receive(:success?).and_return(true)
				allow(party_double).to receive(:deep_symbolize_keys).and_return(response)
			end

			it 'updates the attribute with the coordinates' do
				expect(driver).to receive(:update).with({ home_coordinates: coordinates })
				driver.send(:geocode_address)
			end
		end

		context 'when geocoding fails' do
			before do
				allow(HTTParty).to receive(:get).and_return(party_double)
				allow(party_double).to receive(:success?).and_return(false)
			end

			it 'does not update the attribute' do
				expect(driver).not_to receive(:update)
				driver.send(:geocode_address)
			end
		end
	end

	describe '#calculate_route' do
		let(:ride) { create(:ride, driver: driver) }

    	context 'when the API call is successful' do
      		let(:response) do
				{ routes: [ { segments: [ { distance: 1000, duration: 300 }, { distance: 500, duration: 150 } ] } ] }
      		end

      		before do
        		allow(HTTParty).to receive(:post).and_return(party_double)
				allow(party_double).to receive(:success?).and_return(true)
				allow(party_double).to receive(:deep_symbolize_keys).and_return(response)
      		end

      		it 'updates the attributes with the calculated route' do
        		expect(ride).to receive(:update).with(
					{ commute_distance: 1000, commute_duration: 300, ride_distance: 500, ride_duration: 150}
				)
				ride.send(:calculate_route)
      		end
    	end

    	context 'when the API call fails' do
			before do
				allow(HTTParty).to receive(:get).and_return(party_double)
				allow(party_double).to receive(:success?).and_return(false)
			end

			it 'does not update the attributes' do
				expect(ride).not_to receive(:update)
				ride.send(:calculate_route)
			end
		end
	end
end
