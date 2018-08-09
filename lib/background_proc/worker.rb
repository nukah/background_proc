module BackgroundProc
  class Worker
    def self.perform_later(*args, **kwargs)
      params = { args: args, kwargs: kwargs }
      JobRecord.new(params: params, klass: name.to_s).save
    end

    def perform(*opts)
      puts "No perform implementation!"
    end
  end
end
