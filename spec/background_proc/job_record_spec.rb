describe BackgroundProc::JobRecord do
  describe '#initialize' do
    context 'builds a record' do
      subject { described_class.new(klass: 'TestClass') }

      it 'klass' do
        expect(subject.klass).to eq('TestClass')
      end
      it 'params' do
        expect(subject.params).to be_empty
      end
    end

    context 'creates a record' do
      subject { described_class.new(params: params).save }
      let(:params) { { key: :value, second: 123 } }

      it 'record is persisted' do
        expect { subject }.to change { BackgroundProc::JobRecord.count }
      end

      it 'params is kind of hash' do
        expect(subject.params).to be_kind_of(Hash)
      end

      it 'with enqueued_at present' do
        expect(subject.enqueued_at).not_to be_nil
      end
    end
  end

  describe '#in_work!' do
    let(:job) { described_class.create(klass: 'TestClass') }
    subject { job.in_work! }

    it { expect { subject }.to change { job.in_progress }.to true }
  end

  describe '#done!' do
    let(:job) { described_class.create(klass: 'TestClass', in_progress: true) }
    subject { job.done! }

    it { expect { subject }.to change { job.in_progress }.to false }
    it { expect { subject }.to change { job.result }.to true }

    context 'shouldnt change in_progress if its already false' do
      let(:job) { described_class.create(klass: 'TestClass', in_progress: false) }

      it { expect { subject }.not_to change { job.in_progress } }
    end
  end

  describe '#fail!' do
    let(:job) { described_class.create(klass: 'TestClass', in_progress: true) }
    context 'simple' do
      subject { job.fail! }

      it { expect { subject }.not_to change { job.failure_message } }
    end

    context 'with_message' do
      subject { job.fail!('message') }

      it { expect { subject }.to change { job.failure_message }.to('message') }
    end
  end
end
