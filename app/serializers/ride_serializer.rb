# == Schema Information
#
# Table name: rides
#
#  id                      :bigint           not null, primary key
#  commute_distance        :float
#  commute_duration        :float
#  deleted_at              :datetime
#  destination_address     :string           not null
#  destination_coordinates :string
#  earnings                :float
#  ride_distance           :float
#  ride_duration           :float
#  score                   :float
#  start_address           :string           not null
#  start_coordinates       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  driver_id               :bigint
#  external_id             :string           not null
#
# Indexes
#
#  index_rides_on_destination_address                    (destination_address)
#  index_rides_on_driver_id                              (driver_id)
#  index_rides_on_external_id                            (external_id)
#  index_rides_on_start_address                          (start_address)
#  index_rides_on_start_address_and_destination_address  (start_address,destination_address) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (driver_id => drivers.id)
#
class RideSerializer < ActiveModel::Serializer
  attributes :external_id, :score, :earnings,
             :commute_distance, :commute_duration,
             :ride_distance, :ride_duration,
             :start_address, :destination_address

  def score
    object.score
  end

  def earnings
    object.earnings
  end
end
