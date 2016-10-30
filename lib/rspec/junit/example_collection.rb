module RSpec
  class JUnit
    class ExampleCollection
      include ::Enumerable

      attr_reader :examples

      def initialize(examples = [])
        @examples = examples
      end

      def <<(example)
        @examples << example
      end

      def each(&block)
        @examples.each(&block)
      end

      def each_testsuite
        group_by(&:testsuite).each do |testsuite, examples|
          yield testsuite, self.class.new(examples)
        end
      end

      def passed
        select(&:passed?)
      end

      def failed
        select(&:failed?)
      end

      def pending
        select(&:pending?)
      end
    end
  end
end
