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
class Ride < ApplicationRecord
    # Dependencies and Extensions
    include ExternalId
    extend FriendlyId

    # Configuration
    friendly_id :external_id
    external_id :external_id, prefix: 'R-', bytes: 5
    acts_as_paranoid

    # Validations
    validates :external_id, uniqueness: true

    # Callbacks
    after_create :geocode_address, :calculate_route

    after_commit :calculate_earnings_and_score, on: :create
    # Could put an after update hook to reload the coordinates if the address is changed
    # Also not super concerned here about failures on the API calls since this record is already committed to the database when these hooks fires

    # Associations
    belongs_to :driver

    # Data Serialization
    serialize :start_coordinates, Array # [Longitude, Latitude]
    serialize :destination_coordinates, Array # [Longitude, Latitude]

    # Scopes
    scope :ordered, -> { order(score: :desc) }

    # Constants
    BASE_PAY = 12
    BASE_MILES = 5
    MILE_RATE = 1.5
    BASE_DURATION = 900
    SIXTY_SECONDS = 60
    MINUTE_RATE = 0.7

    def calculate_earnings
        # Calculate earnings for a ride based on its duration and distance
        # If the ride duration is longer than 15 minutes, charge for additional time
        # If the ride distance is longer than 5 miles, charge for additional distance
        excess_duration = [ride_duration - BASE_DURATION, 0].max
        additional_duration_earnings = excess_duration * (MINUTE_RATE / SIXTY_SECONDS)

        excess_miles = [ride_distance - BASE_MILES, 0].max
        additional_mile_earnings = excess_miles * MILE_RATE

        BASE_PAY + additional_mile_earnings + additional_duration_earnings
    end

    def calculate_score(earnings)
        # Calculate the score for a ride based on the earnings and the total duration of the commute and ride
        earnings / (commute_duration + ride_duration)
    end

    private

    def calculate_earnings_and_score
        earnings = calculate_earnings
        score = calculate_score(earnings)
        self.update(earnings: earnings, score: score)
    end

    def geocode_address
        # Geocode the start and destination addresses to get their coordinates
        GeocoderService.geocode_address(self, 'start_coordinates', start_address)
        GeocoderService.geocode_address(self, 'destination_coordinates', destination_address)
    end

    def calculate_route
        # Calculate the route for a ride based on the driver's home coordinates, the start coordinates, and the destination coordinates
        GeocoderService.calculate_route(self, self.driver.home_coordinates, start_coordinates, destination_coordinates)
    end
end
