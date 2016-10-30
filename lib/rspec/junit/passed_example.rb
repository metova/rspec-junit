module RSpec
  class JUnit
    class PassedExample < Example
      def passed?
        true
      end
    end
  end
end
