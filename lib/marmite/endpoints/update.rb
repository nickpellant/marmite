# frozen_string_literal: true
module Marmite
  module Endpoints
    # Controller actions for the #update endpoint
    module Update
      include Marmite::Mixins::ExceptionRenderer

      # Sends the request to be processed
      def update
        self.class.update_service.new(
          controller: self,
          resource_id: params[:id],
          attributes: update_params
        ).call
      end

      # Responds to request with update_conflict status
      def update_conflict(resource:)
        render_json_error(
          code: :update_validation_failed,
          status: :conflict,
          options: { details: resource.errors }
        )
      end

      # Responds to request with update_not_found status
      def update_not_found
        render_json_error(code: :update_not_found, status: :not_found)
      end

      # Responds to request with update_ok status and resource
      def update_ok(resource:)
        render json: resource, status: :ok
      end

      private

      def update_params
        {}
      end
    end
  end
end
