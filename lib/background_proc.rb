require 'background_proc/version'
require 'active_support/all'
require 'sequel'
require 'oj'
require 'pry'

module BackgroundProc
  autoload :Handler, 'background_proc/handler'
  autoload :WorkerProcess, 'background_proc/worker_process'
  autoload :Worker, 'background_proc/worker'
  autoload :JobRecord, 'background_proc/job_record'

  DB = Sequel.connect('sqlite://jobs.db')
  DB.create_table? :job_records do
    primary_key :id
    String :klass
    Json :params
    Datetime :enqueued_at
    Datetime :done_at
    Boolean :result
    Boolean :in_progress, default: false
    String :failure_message
  end
end
