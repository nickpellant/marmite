# frozen_string_literal: true
module Marmite
  module Policies
    # Checks if a resource update has errors
    class DoesTheResourceHaveErrors
      # Initializes an instance
      # @param resource [Resource] the resource
      def initialize(resource:)
        @resource = resource
      end

      # Checks if the resource has errors
      # @return [Boolean] whether the resource has errors or not
      def call
        resource.errors.any?
      end

      private

      attr_reader :resource
    end
  end
end
