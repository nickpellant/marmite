# frozen_string_literal: true
module Marmite
  module Services
    # Processes a create API request and selects a response
    class CreateEndpoint
      include Mixins::InferEndpointResource
      include Mixins::ServiceHooks

      # Initializes an instance
      # @param attributes [Hash] the attributes to create with
      # @param controller [ActionController::API] the resource controller
      def initialize(attributes:, controller:)
        @controller = controller
        @attributes = attributes
      end

      # If the resource is created it selects a created response
      # If the resource create fails it selects a conflict response
      def call
        resource_constant.transaction do
          call_before_validations

          perform_create

          call_after_creates

          return create_created
        end

      rescue ActiveRecord::RecordInvalid
        create_conflict
      end

      private

      attr_reader :attributes, :controller

      # Performs save on resource
      # @return [Boolean] if the resource is saved return true, else false
      def perform_create
        resource.save!
      end

      # Resource to create and render in response
      # @return [Resource] new instance of resource with attributes set
      def resource
        @resource ||= begin
          resource_constant.new(attributes)
        end
      end

      # Responds to request with create_conflict action
      def create_conflict
        controller.create_conflict(resource: resource)
      end

      # Responds to request with create_created action
      def create_created
        controller.create_created(resource: resource)
      end
    end
  end
end
