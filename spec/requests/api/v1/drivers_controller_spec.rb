require 'rails_helper'

describe Api::V1::DriversController, type: :controller do
	describe 'GET #show' do
		let!(:ride) { create(:ride, driver: driver) }
		let(:driver) { create(:driver) }
		let(:headers) { { 'X-ACCESS-TOKEN': ENV['API_TOKEN'] } }
		let(:params) { { driver_id: driver.id } }

		subject { get :show, params: params }

		before do
			request.headers.merge!(headers)
		end

		context 'authentication' do
			context 'with correct authentication' do
				it 'succeeds' do
					subject
					expect(response).to be_successful
				end
			end

			context 'with incorrect authentication' do
				before do
					request.headers.merge!({ 'X-ACCESS-TOKEN': 'BOGUS' } )
				end

				it 'fails' do
					subject
					expect(response).to have_http_status(:unauthorized)
					expect(response.body).to eq("{\"error\":\"Authentication is required\"}")
				end
			end
		end

		context 'with valid parameters' do
			let(:params) { { driver_id: driver.id } }

			it 'returns a success response' do
				subject
				expect(response).to be_successful
			end

			it 'returns the serialized rides for the driver' do
				subject
				res = JSON.parse(response.body)
				expect(res['rides']).to include(JSON.parse(RideSerializer.new(ride).to_json))
			end

			it 'returns the meta data for the rides' do
				subject
				res = JSON.parse(response.body)
				expect(res['meta']['current_page']).to eq(1)
				expect(res['meta']['total_pages']).to eq(1)
			end
		end

		context 'with invalid driver id' do
			let(:params) { { driver_id: 'bogus'.to_json } }

			it 'returns a not found response' do
				subject
				expect(response).to have_http_status(:not_found)
			end
		end

		context 'with external id' do
			let(:params) { { driver_id: driver.external_id.to_json } }

			it 'returns a success response' do
				# TODO: FIX TO NOT CALL GEOCODER
				subject
				expect(response).to be_successful
			end
		end

		context 'with pagination' do
			let!(:rides) { create_list(:ride, 20, driver: driver) }
			let(:page) { 2 }

			before { get :show, params: { driver_id: driver.id, page: page } }

			it 'returns the second page of rides for the driver' do
				expected_rides = Ride.ordered.where(driver_id: driver.id).paginate(page: page)
				serialized = ActiveModelSerializers::SerializableResource.new(
					expected_rides,
					each_serializer: RideSerializer
				).as_json
				res = JSON.parse(response.body)['rides'].map { |r| r.transform_keys(&:to_sym) }
				expect(res).to eq(serialized)
			end

			it 'returns the correct meta data for the second page of rides' do
				res = JSON.parse(response.body)
				expect(res['meta']['current_page']).to eq(2)
				expect(res['meta']['total_pages']).to eq(3)
			end

			it 'sorts in descending order of score' do
				res = JSON.parse(response.body)['rides']
				expect(res.first['score']).to be >= (res.first['score'])
			end
		end
	end
end
