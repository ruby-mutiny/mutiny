require_relative "command_line"

test_suite = ARGV[0]
puts "Test suite: #{test_suite}"

puts CommandLine.new(test_suite, noisy: true).run
