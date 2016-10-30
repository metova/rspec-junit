require 'rspec/core/backtrace_formatter'

module RSpec
  class JUnit
    class FailedExample < Example
      def failed?
        true
      end

      def error_message
        "failed #{name}"
      end

      def exception
        @notification.exception
      end

      def exception_message
        exception.message || ''
      end

      def backtrace
        RSpec::Core::BacktraceFormatter.new.format_backtrace(exception.backtrace || [])
      end

      def details
        [exception_message, backtrace].join "\n"
      end
    end
  end
end
