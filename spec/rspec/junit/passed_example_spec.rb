describe RSpec::JUnit::PassedExample do
  subject { described_class.new notification }

  let(:notification) { double :notification }

  it 'responds to status predicates properly' do
    expect(subject).to be_passed
    expect(subject).to_not be_pending
    expect(subject).to_not be_failed
  end
end
