# frozen_string_literal: true
module Marmite
  module Mixins
    # Infers information about what the resource is
    module InferEndpointResource
      # Infers the Resource name from the controller
      def resource_name
        @resource_name ||= begin
          resource_name = controller.class.name.demodulize
          resource_name.slice!('Controller')
          resource_name.singularize
        end
      end

      # Converts the resource_name to a constant
      def resource_constant
        @resource_constant ||= resource_name.constantize
      end

      # Infers the Query object using the resource_name
      def resource_query
        @resource_query ||= begin
          "#{resource_name}Query".constantize
        rescue NameError
          Marmite::Queries::ResourceQuery
        end
      end
    end
  end
end
