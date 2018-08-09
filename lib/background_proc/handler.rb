module BackgroundProc
  class Handler
    WORKER_COUNT = 1
    attr_accessor :worker_pids, :logger

    def initialize
      @worker_pids = []
    end

    def run!
      puts 'Starting workers!'
      Array.new(workers).map { run_worker }
      Process.wait
    rescue Interrupt
      worker_pids.each { |pid| Process.kill('HUP', pid) }
    end

    private

    def workers
      ENV['WORKERS'] || WORKER_COUNT
    end

    def run_worker
      worker_pids << Process.fork { WorkerProcess.perform }
    end
  end
end
