describe RSpec::JUnit::Example do
  subject { described_class.new notification }

  let(:notification) do
    double :notification, metadata: { example_group: { description: 'foo' }, full_description: 'bar' }
  end

  it 'responds to status predicates properly' do
    expect(subject).to_not be_passed
    expect(subject).to_not be_pending
    expect(subject).to_not be_failed
  end

  describe '#testsuite' do
    it 'returns the description of the example group' do
      expect(subject.testsuite).to eq 'foo'
    end
  end

  describe '#name' do
    it 'returns the full description of the example' do
      expect(subject.name).to eq 'bar'
    end
  end
end
