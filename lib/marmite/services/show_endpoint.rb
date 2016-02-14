# frozen_string_literal: true
module Marmite
  module Services
    # Processes a show API request and selects a response
    class ShowEndpoint
      include Mixins::InferEndpointResource

      # Initializes an instance
      # @param controller [ActionController::API] the resource controller
      # @param find_by_conditions [Hash] the find by conditions
      def initialize(controller:, find_by_conditions:)
        @controller = controller
        @find_by_conditions = find_by_conditions
      end

      # Selects an ok response if the resource is found
      # If the resource is not found it selects a not_found response
      def call
        return show_ok if resource_found?

        show_not_found
      end

      private

      attr_reader :controller, :find_by_conditions

      # Checks if the resource was found
      # @see Policies::WasTheResourceFound
      def resource_found?
        Policies::WasTheResourceFound.new(resource: resource).call
      end

      # Resource to render in response
      # @return [Resource] if the resource object was found
      # @return [nil] if the resource object was not found
      def resource
        @resource ||= begin
          resource_query
                      .new(relation: resource_constant.all)
                      .find_for_show(find_by_conditions: find_by_conditions)
        end
      end

      # Responds to request with show_not_found action
      def show_not_found
        controller.show_not_found
      end

      # Responds to request with show_ok action
      def show_ok
        controller.show_ok(resource: resource)
      end
    end
  end
end
