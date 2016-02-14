# frozen_string_literal: true
module Marmite
  module Services
    # Processes an update API request and selects a response
    class UpdateEndpoint
      include Mixins::InferEndpointResource
      include Mixins::ServiceHooks

      # Initializes an instance
      # @param attributes [Hash] the attributes to update
      # @param controller [ActionController::API] the resource controller
      # @param resource_id [Integer, String] the resource id
      def initialize(attributes:, controller:, resource_id:)
        @controller = controller
        @attributes = attributes
        @resource_id = resource_id
      end

      # If the resource is not found it selects a not_found response
      # If the resource is found and updated it selects an ok response
      # If the resource update fails it selects a conflict response
      def call
        return update_not_found unless resource_found?

        resource_constant.transaction do
          call_before_validations

          perform_update

          return update_ok
        end

      rescue ActiveRecord::RecordInvalid
        update_conflict
      end

      private

      attr_reader :attributes, :controller, :resource_id

      # Performs update on resource
      # @return [Boolean] if the resource updates return true, else false
      def perform_update
        resource.update!(attributes)
      end

      # Checks if the resource was found
      # @see Policies::WasTheResourceFound
      def resource_found?
        Policies::WasTheResourceFound.new(resource: resource).call
      end

      # Resource to update and render in response
      # @return [Resource] if the resource object was found
      # @return [nil] if the resource object was not found
      def resource
        @resource ||= begin
          resource_query
                      .new(relation: resource_constant.all)
                      .find_for_update(resource_id: resource_id)
        end
      end

      # Responds to request with update_conflict action
      def update_conflict
        controller.update_conflict(resource: resource)
      end

      # Responds to request with update_not_found action
      def update_not_found
        controller.update_not_found
      end

      # Responds to request with update_ok action
      def update_ok
        controller.update_ok(resource: resource)
      end
    end
  end
end
