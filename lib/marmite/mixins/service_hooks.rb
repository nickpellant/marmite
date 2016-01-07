module Marmite
  module Mixins
    # Implement hooks into services
    module ServiceHooks
      extend ActiveSupport::Concern

      class_methods do
        attr_reader :before_validations

        # Queues a method call to the before_validation hook
        # @param method [Symbol] the method to call
        def before_validation(method)
          @before_validations ||= []
          @before_validations << method
        end
      end

      included do
        # Calls methods queued for before_validation hook
        def call_before_validations
          return unless self.class.try(:before_validations)
          self.class.before_validations.each { |method| send(method) }
        end
      end
    end
  end
end
