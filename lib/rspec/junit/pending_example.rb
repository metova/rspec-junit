module RSpec
  class JUnit
    class PendingExample < Example
      def pending?
        true
      end
    end
  end
end
