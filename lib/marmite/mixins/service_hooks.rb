# frozen_string_literal: true
module Marmite
  module Mixins
    # Implement hooks into services
    module ServiceHooks
      extend ActiveSupport::Concern

      class_methods do
        attr_reader :before_validations
        attr_reader :after_creates

        # Queues a method call to the before_validation hook
        # @param method [Symbol] the method to call
        def before_validation(method)
          @before_validations ||= []
          @before_validations << method
        end

        # Queues a method call to the after_create hook
        # @param method [Symbol] the method to call
        def after_create(method)
          @after_creates ||= []
          @after_creates << method
        end
      end

      included do
        # Calls methods queued for before_validation hook
        def call_before_validations
          return unless self.class.try(:before_validations)
          self.class.before_validations.each { |method| send(method) }
        end

        # Calls methods queued for after_create hook
        def call_after_creates
          return unless self.class.try(:after_creates)
          self.class.after_creates.each { |method| send(method) }
        end
      end
    end
  end
end
