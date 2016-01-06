module Marmite
  module Mixins
    # Implement hooks into services
    module ServiceHooks
      attr_reader :before_validations

      # Queues a method call to the before_validation hook
      # @param method [Symbol] the method to call
      def before_validation(method)
        @before_validations ||= []
        before_validations << method
      end

      # Calls methods queued for before_validation hook
      def call_before_validations
        return unless before_validations
        before_validations.each { |method| send(method) }
      end
    end
  end
end
