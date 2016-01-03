module Marmite
  # Controller Mixin to activate endpoint actions
  module Controller
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :create_service, :update_service

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
      def update_endpoint(service: Marmite::Services::UpdateEndpoint)
        @update_service = service
        include(Marmite::Endpoints::Update)
      end

      # Activates the #create endpoint
      # @see Marmite::Endpoints::Create
      def create_endpoint(service: Marmite::Services::CreateEndpoint)
        @create_service = service
        include(Marmite::Endpoints::Create)
      end
    end
  end
end
