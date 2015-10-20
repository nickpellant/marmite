module Marmite
  module Endpoints
    # Controller actions for the #update endpoint
    module Update
      # Sends the request to be processed
      def update
        Marmite::Services::UpdateEndpoint.new(
          controller: self,
          resource_id: params[:id],
          attributes: update_params
        ).call
      end

      # Responds to request with update_conflict status
      def update_conflict(resource:)
        render json: resource, status: :conflict
      end

      # Responds to request with update_not_found status
      def update_not_found
        render json: {}, status: :not_found
      end

      # Responds to request with update_ok status and resource
      def update_ok(resource:)
        render json: resource, status: :ok
      end
    end
  end
end
