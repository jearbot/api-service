require 'rails_helper'

describe RideSerializer, type: :serializer do
    let(:ride) { build_stubbed(:ride) }
    let(:serializer) { described_class.new(ride) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer).as_json }

    subject { serialization }

    it { is_expected.to include(external_id: ride.external_id) }
    it { is_expected.to include(score: ride.score) }
    it { is_expected.to include(earnings: ride.earnings) }
    it { is_expected.to include(commute_distance: ride.commute_distance) }
    it { is_expected.to include(commute_duration: ride.commute_duration) }
    it { is_expected.to include(ride_distance: ride.ride_distance) }
    it { is_expected.to include(ride_duration: ride.ride_duration) }
    it { is_expected.to include(start_address: ride.start_address) }
    it { is_expected.to include(destination_address: ride.destination_address) }
end
