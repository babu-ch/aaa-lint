require 'rubocop'
require 'rubocop/rspec/expect_offense'

require_relative '../lib/rubocop-aaa'

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
