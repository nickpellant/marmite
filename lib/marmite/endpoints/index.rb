module Marmite
  module Endpoints
    # Controller actions for the #index endpoint
    module Index
      # Sends the request to be processed
      def index
        Marmite::Services::IndexEndpoint.new(
          controller: self, filter_conditions: index_params
        ).call
      end

      # Responds to request with index_ok status and resources
      def index_ok(resources:)
        render json: resources, status: :ok, include: index_includes
      end

      private

      def index_includes
        nil
      end
    end
  end
end
