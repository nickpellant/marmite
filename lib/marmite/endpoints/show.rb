module Marmite
  module Endpoints
    # Controller actions for the #show endpoint
    module Show
      include Marmite::Mixins::ExceptionRenderer

      # Sends the request to be processed
      def show
        Marmite::Services::ShowEndpoint.new(
          controller: self, find_by_conditions: show_params
        ).call
      end

      # Responds to request with show_ok status and resource
      def show_ok(resource:)
        render json: resource, status: :ok, include: show_includes
      end

      # Responds to request with show_not_found status
      def show_not_found
        render_json_error(code: :show_not_found, status: :not_found)
      end

      private

      def show_includes
        nil
      end
    end
  end
end
