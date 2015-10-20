module Marmite
  # Controller Mixin to activate endpoint actions
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      # Activates the #show endpoint
      # @see Marmite::Endpoints::Show
      def show_endpoint
        include(Marmite::Endpoints::Show)
      end

      # Activates the #index endpoint
      # @see Marmite::Endpoints::Index
      def index_endpoint
        include(Marmite::Endpoints::Index)
      end

      # Activates the #update endpoint
      # @see Marmite::Endpoints::Update
      def update_endpoint
        include(Marmite::Endpoints::Update)
      end
    end
  end
end
