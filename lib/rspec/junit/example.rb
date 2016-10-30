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
        @notification.metadata[:full_description]
      end

      def testsuite
        @notification.metadata[:example_group][:description]
      end

      def run_time
        @notification.metadata[:execution_result].run_time
      end
    end
  end
end
