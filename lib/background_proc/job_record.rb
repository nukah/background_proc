module BackgroundProc
  class JobRecord < Sequel::Model
    self.strict_param_setting = false

    def initialize(**options)
      super(options)
      self.params = Oj.dump(options[:params] || {})
    end

    def before_create
      self.enqueued_at = Time.now
      super
    end

    def self.to_do
      where(done_at: nil, in_progress: false, result: nil)
    end

    def params
      Oj.load(super).with_indifferent_access
    end

    def in_work!
      set(in_progress: true)
      save
    end

    def done!
      set(in_progress: false, done_at: Time.current, result: true)
      save
    end

    def fail!(message = nil)
      set(in_progress: false, result: false, failure_message: message)
      save
    end
  end
end
