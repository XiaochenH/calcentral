describe DegreeProgress::MyUndergradRequirements do

  let(:model) { described_class.new(user_id) }
  let(:user_id) { '12345' }

  describe '#get_feed_internal' do
    let(:flag) { :cs_degree_progress_ugrd_student }
    subject { model.get_feed_internal }

    it_behaves_like 'a proxy that observes a feature flag'
    it_behaves_like 'a proxy that returns undergraduate milestone data'

    it 'does not include the Academic Progress Report link in the response' do
      expect(subject[:feed][:links]).not_to be
    end
  end
end
