describe BackgroundProc::WorkerProcess do
  describe '#perform' do
    subject { described_class.new.perform }

    it do
      expect_any_instance_of(described_class).to receive(:loop).and_return(true)
      subject
    end
  end

  describe '#scope' do
    subject { described_class.new.scope }
    before { BackgroundProc::JobRecord.create(klass: 'Worker', params: {}) }
    let(:job) { BackgroundProc::JobRecord.last }

    it { expect(subject.all).to include(job) }
  end

  describe '#run_job' do
    subject { described_class.new.run_job(job) }
    let(:job) { BackgroundProc::JobRecord.create(klass: 'BackgroundProc::Worker', params: {}) }

    it { expect { subject }.to raise_error(NotImplementedError) }
    it 'calls for perform method on worker' do
      expect_any_instance_of(BackgroundProc::Worker).to receive(:perform).and_return(true)
      subject
    end
  end
end
