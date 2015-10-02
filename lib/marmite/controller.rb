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
    end
  end
end
