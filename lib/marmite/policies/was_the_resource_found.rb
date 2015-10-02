module Marmite
  module Policies
    # Checks if a resource was found or not
    class WasTheResourceFound
      # Initializes an instance
      # @param resource [Resource] the resource
      def initialize(resource:)
        @resource = resource
      end

      # Checks if the resource was found
      # @return [Boolean] whether the resource was found or not
      def call
        resource.present?
      end

      private

      attr_reader :resource
    end
  end
end
