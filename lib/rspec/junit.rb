require 'rspec'
require 'rspec/core/formatters'
require 'rspec/junit/version'
require 'rspec/junit/example_collection'
require 'rspec/junit/example'
require 'rspec/junit/failed_example'
require 'rspec/junit/passed_example'
require 'rspec/junit/pending_example'
require 'rspec/junit/renderer'

class RSpec::JUnit
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending, :dump_summary

  attr_reader :output, :examples

  def initialize(output)
    @output = output
    @examples = RSpec::JUnit::ExampleCollection.new
  end

  def example_passed(notification)
    @examples << RSpec::JUnit::PassedExample.new(notification)
  end

  def example_failed(notification)
    @examples << RSpec::JUnit::FailedExample.new(notification)
  end

  def example_pending(notification)
    @examples << RSpec::JUnit::PendingExample.new(notification)
  end

  def dump_summary(summary)
    renderer = RSpec::JUnit::Renderer.new @examples, summary.duration
    @output.puts renderer.render
  end
end
