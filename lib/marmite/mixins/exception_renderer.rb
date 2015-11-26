module Marmite
  module Mixins
    # Performs exception rendering for API endpoints
    module ExceptionRenderer
      # Renders a JSON error response
      # @param code [Symbol] the error code
      # @param status [Symbol] the HTTP status to respond with
      # @param options [Hash] additional error options
      # @return renders a JSON response for the exception
      def render_json_error(code:, status:, options: {})
        error = {
          title: I18n.t("error_codes.#{code}.message"),
          status: status
        }.merge(options)

        render json: { errors: [error] }, status: status
      end
    end
  end
end
