describe RSpec::JUnit::FailedExample do
  subject { described_class.new notification }

  let(:notification) do
    double :notification, exception: exception, example: double(metadata: { example_group: { description: 'foo' }, full_description: 'bar' })
  end

  let(:exception) do
    double :exception, message: 'Test', backtrace: ['Your shit is broken', 'For real']
  end

  it 'responds to status predicates properly' do
    expect(subject).to_not be_passed
    expect(subject).to_not be_pending
    expect(subject).to be_failed
  end

  describe '#error_message' do
    it 'returns the description of the example group with a failed message' do
      expect(subject.error_message).to eq 'failed bar'
    end
  end

  describe '#exception' do
    it 'returns the exception from the notification' do
      expect(subject.exception).to eq exception
    end
  end

  describe '#exception_message' do
    it 'returns the message on the exception, if it exists' do
      expect(subject.exception_message).to eq 'Test'
    end

    it 'returns a blank string if the exception does not have a message' do
      expect(exception).to receive(:message) { nil }
      expect(subject.exception_message).to eq ''
    end
  end

  describe '#backtrace' do
    it 'returns the formatted backtrace if it has a backtrace' do
      expect(subject.backtrace).to eq ['Your shit is broken', 'For real']
    end

    it 'returns a blank string if the exception does not have a backtrace' do
      expect(exception).to receive(:backtrace) { nil }
      expect(subject.backtrace).to eq []
    end
  end

  describe '#details' do
    it 'returns the exception message and backtrace' do
      expect(subject.details).to eq "Test\nYour shit is broken\nFor real"
    end
  end
end
