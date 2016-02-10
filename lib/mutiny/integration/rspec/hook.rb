module Mutiny
  class Integration
    class RSpec < self
      class Hook
        attr_reader :hook

        def initialize(hook)
          @hook = hook
        end

        def install(configuration)
          configuration.reporter.register_listener(self, :example_started)
          configuration.reporter.register_listener(self, :example_failed)
          configuration.reporter.register_listener(self, :example_passed)
        end

        def example_started(notification)
          example = notification.example
          hook.before(example) unless example.pending? || example.skipped?
        end

        def example_failed(notification)
          hook.after(notification.example)
        end

        def example_passed(notification)
          hook.after(notification.example)
        end
      end
    end
  end
end
