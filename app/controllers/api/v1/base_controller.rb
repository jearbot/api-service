module Api
  module V1
    class BaseController < ApplicationController
      include Rails::Pagination

      before_action :authenticate

      private

      def authenticate
        return if request.headers['X-ACCESS-TOKEN']&.strip == ENV['API_TOKEN']
        render(json: { error: 'Authentication is required' }, status: :unauthorized)
      end

      def meta(object)
        {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.previous_page,
          total_pages: object.total_pages,
          total_count: object.total_entries
        }
      end
    end
  end
end
