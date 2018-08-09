require 'bundler/setup'
require 'background_proc'

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expose_dsl_globally = true

  config.before(:suite) do
    BackgroundProc::JobRecord.all.each(&:delete)
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
