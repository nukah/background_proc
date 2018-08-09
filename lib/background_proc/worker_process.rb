module BackgroundProc
  class WorkerProcess
    class UnknownWorkerClass < StandardError; end
    attr_reader :logger

    def initialize
      @logger = Logger.new(STDOUT)
    end

    def self.perform
      new.perform
    end

    def perform
      logger.info("Starting worker: #{Process.pid}")
      loop do
        begin
          job = isolate do
            job = scope.first
            job.in_work! if job.present?
            job
          end
          sleep(3) && next unless job.present?
          run_job(job)
        rescue Interrupt
          logger.info 'Stopping worker'
          break
        end
      end
    end

    def scope
      JobRecord.to_do.order(:enqueued_at)
    end

    def run_job(job)
      worker_class = job.klass.classify.safe_constantize
      raise UnknownWorkerClass unless worker_class.present?
      logger.info "[#{Process.pid}] Starting job #{worker_class}"
      params = job.params[:args] || []
      kparams = job.params[:kwargs] || {}
      logger.info "With params: #{[params, kparams]}"
      worker_class.new.perform(*params, **kparams.symbolize_keys)
      job.done!
    rescue UnknownWorkerClass
      logger.error 'Job failed!'
      isolate { job.fail!('Non-existant worker class') }
    rescue StandardError => exception
      logger.error "Job failed! #{exception.message}"
      isolate { job.fail!(exception.message) }
    end

    def isolate
      DB.transaction do
        yield
      end
    rescue SQLite3::BusyException
      sleep(1)
      retry
    end
  end
end
