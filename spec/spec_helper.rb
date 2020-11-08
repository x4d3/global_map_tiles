require "bundler/setup"
require "global_map_tiles"
require_relative "have_values_within_matcher"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def have_values_within(percent)
  HaveValuesWithinMatcher.new(percent)
end
