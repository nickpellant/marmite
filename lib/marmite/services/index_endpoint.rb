module Marmite
  module Services
    # Processes an index API request and selects a response
    class IndexEndpoint
      include Mixins::InferEndpointResource

      # Initializes an instance
      # @param controller [ActionController::API] the resource controller
      # @param filter_conditions [Hash] the filter conditions
      def initialize(controller:, filter_conditions:)
        @controller = controller
        @filter_conditions = filter_conditions
      end

      # Responds with the resources relation
      def call
        index_ok
      end

      private

      attr_reader :controller, :filter_conditions

      # Resources to render in response
      # @return [Relation]
      def resources
        @resource ||= begin
          resource_query
          .new(relation: resource_constant.all)
          .find_for_index(filter_conditions: filter_conditions)
        end
      end

      # Responds to request with index_ok action
      def index_ok
        controller.index_ok(resources: resources)
      end
    end
  end
end
