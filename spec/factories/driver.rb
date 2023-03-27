FactoryBot.define do
    factory :driver do
        external_id { "D-#{Faker::Alphanumeric.alphanumeric(number: 10).upcase}" }
        home_address { Faker::Address.full_address }
        home_coordinates { [Faker::Address.longitude, Faker::Address.latitude] }

        after(:create, :build) do |driver|
            driver.class.set_callback(:create, :after, :geocode_address)
            driver.class.skip_callback(:create, :after, :geocode_address)
        end

        factory :driver_with_callbacks do
            after(:create, :build) do |driver|
                driver.send(:geocode_address)
            end
        end
    end
end
