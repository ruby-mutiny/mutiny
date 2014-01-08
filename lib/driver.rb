require_relative "mutiny"
require_relative "test"

test_suite = ARGV[0]
puts "Test suite: #{test_suite}"

puts Mutiny.new(test_suite, noisy: true).run
