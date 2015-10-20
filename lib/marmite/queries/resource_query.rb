module Marmite
  module Queries
    # Performs database interactions for the Resource
    class ResourceQuery
      attr_reader :search

      # Initializes an instance
      # @param relation [ActiveRecord::Relation] the relation
      def initialize(relation:)
        @search = relation.extending(Scopes)
      end

      # Finds a record to show
      # @param find_by_conditions [Hash] the find by conditions
      # @return [Resource] if the resource object was found
      # @return [nil] if the resource object was not found
      def find_for_show(find_by_conditions:)
        search.find_by(find_by_conditions)
      end

      # Finds records to index
      # @param filter_conditions [Hash] the filter by conditions
      # @return [Relation]
      def find_for_index(filter_conditions:)
        search.where(filter_conditions)
      end

      # Finds a record to update
      # @param resource_id [Hash] the resource id
      # @return [Resource] if the resource object was found
      # @return [nil] if the resource object was not found
      def find_for_update(resource_id:)
        search.find_by(id: resource_id)
      end

      # ResourceQuery scopes
      module Scopes
      end
    end
  end
end
