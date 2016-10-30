require 'builder'

module RSpec
  class JUnit
    class Renderer
      attr_reader :examples, :duration, :builder

      def initialize(examples, duration = 0)
        @examples = examples
        @duration = duration
        @builder = Builder::XmlMarkup.new indent: 2
      end

      def render
        builder.instruct! :xml, version: '1.0', encoding: 'UTF-8'
        render_testsuites
        builder.target!
      end

      def render_testsuites
        builder.testsuites(testsuites_attributes) do
          @examples.each_testsuite do |testsuite, examples|
            render_testsuite testsuite, examples
          end
        end
      end

      def render_testsuite(testsuite, examples)
        builder.testsuite(testsuite_attributes(testsuite, examples)) do
          examples.each do |example|
            render_testcase example
          end
        end
      end

      def render_testcase(example)
        builder.testcase(testcase_attributes(example)) do
          if example.failed?
            builder.failure(message: example.error_message, type: :failed) do
              builder.cdata! example.details
            end
          elsif example.pending?
            builder.skipped
          end
        end
      end

      private
        def testsuites_attributes
          {
            errors: 0,
            tests: examples.count,
            failures: examples.failed.count,
            skipped: examples.pending.count,
            time: duration,
            timestamp: Time.now.iso8601
          }
        end

        def testsuite_attributes(name, examples)
          {
            name: name,
            errors: 0,
            tests: examples.count,
            failures: examples.failed.count,
            skipped: examples.pending.count
          }
        end

        def testcase_attributes(example)
          {
            name: example.name,
            time: example.run_time
          }
        end
    end
  end
end
