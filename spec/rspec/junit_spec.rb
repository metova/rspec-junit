describe RSpec::JUnit do
  subject { described_class.new output }
  let(:output) { StringIO.new }

  it 'has a version number' do
    expect(RSpec::JUnit::VERSION).not_to be nil
  end

  describe 'RSpec hooks' do
    let(:notification) do
      double :notification, metadata: { example_group: { description: 'test' } }
    end

    describe '#example_passed' do
      it 'adds a passed example to the results' do
        subject.example_passed notification
        expect(subject.examples.count).to eq 1
        subject.examples.first.tap do |example|
          expect(example).to be_passed
          expect(example.notification).to eq notification
          expect(example.testsuite).to eq 'test'
        end
      end
    end

    describe '#example_failed' do
      it 'adds a failed example to the results' do
        subject.example_failed notification
        expect(subject.examples.count).to eq 1
        subject.examples.first.tap do |example|
          expect(example).to be_failed
          expect(example.notification).to eq notification
          expect(example.testsuite).to eq 'test'
        end
      end
    end

    describe '#example_pending' do
      it 'adds a passed example to the results' do
        subject.example_pending notification
        expect(subject.examples.count).to eq 1
        subject.examples.first.tap do |example|
          expect(example).to be_pending
          expect(example.notification).to eq notification
          expect(example.testsuite).to eq 'test'
        end
      end
    end

    describe '#dump_summary' do
      let(:summary) do
        double :summary, duration: 123
      end

      it 'sets up a renderer' do
        expect(RSpec::JUnit::Renderer).to receive(:new).with(anything, 123) do
          double render: nil
        end
        subject.dump_summary summary
      end

      it 'dumps the result of the renderer into the output' do
        expect(RSpec::JUnit::Renderer).to receive(:new) do
          double render: 'test'
        end

        subject.dump_summary summary
        expect(output.string).to eq "test\n"
      end
    end
  end
end
