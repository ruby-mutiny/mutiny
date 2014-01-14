require_relative "command_line"

test_suite_path = ARGV[0]
puts "Test suite path: #{test_suite_path}"

puts Mutiny::CommandLine.new(test_suite_path, noisy: true).run
