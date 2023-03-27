module Api
  module V1
    class DriversController < BaseController
      before_action :authenticate, only: [:show]
      before_action :set_driver, only: [:show]

      def show
        @rides = Ride.ordered.where(driver_id: @driver.id).paginate(page: params[:page])

        serialized_rides = ActiveModelSerializers::SerializableResource.new(
          @rides,
          each_serializer: RideSerializer
        ).as_json
        render(json: { rides: serialized_rides, meta: meta(@rides) })
      end

      private

      def permitted_params
        params.require(:driver_id)
        params.permit(:driver_id, :page)
      end

      def set_driver
        begin
          @driver = Driver.find(JSON.parse(permitted_params[:driver_id]))
        rescue ActiveRecord::RecordNotFound
          render(json: { error: 'Not Found' }, status: :not_found)
        end
      end
    end
  end
end
