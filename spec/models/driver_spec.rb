require 'rails_helper'

describe Driver, type: :model do
	let(:driver) { create(:driver) }
	
	describe "associations" do
		it { should have_many(:rides).class_name('Ride') }
	end

	describe "validations" do
		subject { create(:driver) }

		it { should validate_uniqueness_of(:home_address) }
		it { should validate_uniqueness_of(:external_id) }
	end

	describe "callbacks" do
		let(:driver) { build(:driver_with_callbacks) }

		subject { driver.save }

		describe 'after_create' do
			it 'geocodes home address' do
                expect_any_instance_of(Driver).to receive(:geocode_address).once
                subject
            end
		end
	end

	describe "methods" do
		describe '#geocode_address' do
            it 'calls geocoder service' do
                expect(GeocoderService).to receive(:geocode_address).with(
                    driver,
					'home_coordinates',
                    driver.home_address
				).once
               driver.send(:geocode_address)
            end
        end
	end
end
