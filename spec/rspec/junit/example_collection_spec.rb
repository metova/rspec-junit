describe RSpec::JUnit::ExampleCollection do
  describe '#<<' do
    it 'adds an example to the collection' do
      example = RSpec::JUnit::Example.new nil
      subject << example
      expect(subject.examples).to eq [example]
    end
  end

  describe '#each_testsuite' do
    it 'yields each example by their testsuite' do
      example1 = RSpec::JUnit::Example.new double(metadata: { example_group: { description: '1' } })
      example2 = RSpec::JUnit::Example.new double(metadata: { example_group: { description: '2' } })
      subject << example1
      subject << example2
      results = []
      subject.each_testsuite { |testsuite, examples| results << [testsuite, examples] }
      expect(results[0][0]).to eq '1'
      expect(results[0][1].examples).to eq [example1]
      expect(results[1][0]).to eq '2'
      expect(results[1][1].examples).to eq [example2]
    end
  end

  describe 'Filtering' do
    subject { described_class.new [example1, example2, example3] }
    let(:example1) { RSpec::JUnit::PassedExample.new nil }
    let(:example2) { RSpec::JUnit::FailedExample.new nil }
    let(:example3) { RSpec::JUnit::PendingExample.new nil }

    describe '#passed' do
      it 'returns the passed examples' do
        expect(subject.passed).to eq [example1]
      end
    end

    describe '#failed' do
      it 'returns the failed examples' do
        expect(subject.failed).to eq [example2]
      end
    end

    describe '#pending' do
      it 'returns the pending examples' do
        expect(subject.pending).to eq [example3]
      end
    end
  end
end
