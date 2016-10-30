require 'timecop'

describe RSpec::JUnit::Renderer do
  let(:passed_example) { RSpec::JUnit::PassedExample.new notification }
  let(:failed_example) { RSpec::JUnit::FailedExample.new notification }
  let(:pending_example) { RSpec::JUnit::PendingExample.new notification }

  let(:notification) do
    double({
      exception: double(:exception, message: 'Test', backtrace: ['Your shit is broken', 'For real']),
      metadata: { example_group: { description: 'test' }, execution_result: double(run_time: 1) }
    })
  end

  describe '#render' do
    subject do
      described_class.new RSpec::JUnit::ExampleCollection.new([
        passed_example,
        failed_example,
        failed_example.dup,
        pending_example
      ])
    end

    describe 'testsuites attributes' do
      it 'renders the total number of tests' do
        expect(subject.render).to match(/testsuites(.*)tests="4"/)
      end

      it 'renders the number of total failed tests' do
        expect(subject.render).to match(/testsuites(.*)failures="2"/)
      end

      it 'renders the number of total pending tests' do
        expect(subject.render).to match(/testsuites(.*)skipped="1"/)
      end

      it 'renders the total duration' do
        subject = described_class.new RSpec::JUnit::ExampleCollection.new([]), 123
        expect(subject.render).to match(/testsuites(.*)time="123"/)
      end
    end

    describe 'each testsuite' do
      before do
        expect(pending_example).to receive(:testsuite) { 'test2' }
      end

      it 'renders the example group name' do
        subject.render.tap do |xml|
          expect(xml).to include 'testsuite name="test"'
          expect(xml).to include 'testsuite name="test2"'
        end
      end

      it 'renders the number of tests in the group' do
        subject.render.tap do |xml|
          expect(xml).to match(/testsuite name="test"(.*)tests="3"/)
          expect(xml).to match(/testsuite name="test2"(.*)tests="1"/)
        end
      end

      it 'renders the number of failed tests in the group' do
        subject.render.tap do |xml|
          expect(xml).to match(/testsuite name="test"(.*)failures="2"/)
          expect(xml).to match(/testsuite name="test2"(.*)failures="0"/)
        end
      end

      it 'renders the number of pending tests in the group' do
        subject.render.tap do |xml|
          expect(xml).to match(/testsuite name="test"(.*)skipped="0"/)
          expect(xml).to match(/testsuite name="test2"(.*)skipped="1"/)
        end
      end
    end

    describe 'each example' do
      it 'includes the test name' do
        expect(passed_example).to receive(:name) { 'passing' }
        expect(subject.render).to match(match(/testcase(.*)name="passing"/))
      end

      it 'includes the example run time' do
        expect(subject.render).to match(match(/testcase(.*)time="1"/))
      end

      context 'test passed' do
        it 'has nothing inside the XML tag' do
          expect(passed_example).to receive(:name) { 'passing' }
          expect(subject.render).to match(%r{testcase(.*)name="passing"(.*)>\s+</testcase>})
        end
      end

      context 'test failed' do
        it 'includes a generic failure message' do
          allow(failed_example).to receive(:name) { 'failed' }
          expect(subject.render).to match(/failure(.*)message="failed failed" type="failed"/)
        end

        it 'includes the exception message and backtrace' do
          allow(failed_example).to receive(:name) { 'failed' }
          expect(subject.render).to match %r{<failure(.*)>\s+<!\[CDATA\[Test\nYour shit is broken\nFor real\]\]>\s+</failure>}
        end
      end

      context 'test pending' do
        it 'has <skipped> inside the XML tag' do
          allow(pending_example).to receive(:name) { 'pending' }
          expect(subject.render).to match %r{testcase(.*)name="pending"(.*)>\s+<skipped/>\s+</testcase>}
        end
      end
    end
  end
end
