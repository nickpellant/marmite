module Marmite
  module Endpoints
    # Controller actions for the #create endpoint
    module Create
      include Marmite::Mixins::ExceptionRenderer

      # Sends the request to be processed
      def create
        Marmite::Services::CreateEndpoint.new(
          controller: self,
          attributes: create_params
        ).call
      end

      # Responds to request with create_conflict status
      def create_conflict(resource:)
        render_json_error(
          code: :create_validation_failed,
          status: :conflict,
          options: { details: resource.errors }
        )
      end

      # Responds to request with create_created status and resource
      def create_created(resource:)
        render json: resource, status: :created
      end

      private

      def create_params
        {}
      end
    end
  end
end
