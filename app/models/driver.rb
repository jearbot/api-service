# == Schema Information
#
# Table name: drivers
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  home_address     :string           not null
#  home_coordinates :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_id      :string           not null
#
# Indexes
#
#  index_drivers_on_external_id   (external_id)
#  index_drivers_on_home_address  (home_address)
#
class Driver < ApplicationRecord
  # Dependencies and Extensions
  include ExternalId
  extend FriendlyId

  # Configuration
  friendly_id :external_id
  external_id :external_id, prefix: 'D-', bytes: 5
  acts_as_paranoid

  # Validations
  validates :home_address, uniqueness: true
  validates :external_id, uniqueness: true

  # Callbacks
  after_create :geocode_address, if: ->(obj) { obj.home_address.present? }
  # Also not super concerned here about failures on the API calls since this record is already committed to the database when these hooks fires

  # Data Serialization
  serialize :home_coordinates, Array # [Longitude, Latitude]

  # Associations
  has_many :rides, class_name: 'Ride'

  private

  def geocode_address
    GeocoderService.geocode_address(self, 'home_coordinates', home_address)
  end
end
