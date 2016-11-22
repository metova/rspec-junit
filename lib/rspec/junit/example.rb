module RSpec
  class JUnit
    class Example
      attr_reader :notification

      def initialize(notification)
        @notification = notification
      end

      def passed?
        false
      end

      def pending?
        false
      end

      def failed?
        false
      end

      def name
        metadata[:full_description]
      end

      def testsuite
        metadata[:example_group][:description]
      end

      def run_time
        metadata[:execution_result].run_time
      end

      private
        def metadata
          @_metadata ||= @notification.example.metadata
        end
    end
  end
end
