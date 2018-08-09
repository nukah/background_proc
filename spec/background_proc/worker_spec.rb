describe BackgroundProc::Worker do
  describe '.perform_later' do
    subject { described_class.perform_later(1,2,3) }

    it { expect { subject }.to change { BackgroundProc::JobRecord.count }.by(1) }

    context 'Job record' do
      before { described_class.perform_later(1, 2, 3) }
      let(:record) { BackgroundProc::JobRecord.last }

      it { expect(record.params).to eq('args' => [1, 2, 3], 'kwargs' => {}) }
    end
  end

  describe '#perform' do
    subject { described_class.new.perform }

    it 'raises not implented exception' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end
end
