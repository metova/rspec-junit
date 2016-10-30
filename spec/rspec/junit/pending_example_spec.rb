describe RSpec::JUnit::PendingExample do
  subject { described_class.new notification }

  let(:notification) { double :notification }

  it 'responds to status predicates properly' do
    expect(subject).to_not be_passed
    expect(subject).to be_pending
    expect(subject).to_not be_failed
  end
end
