require_relative "mutiny"
require_relative "test"

program = File.read(ARGV[0])
puts "Program:"
puts program
puts ""

test_suite = File.read(ARGV[1])
puts "Test suite:"
puts test_suite

tests = test_suite.lines.each_with_index.map do |source, index|
  Test.new(index, source)
end

puts Mutiny.new(program, tests, noisy: true).run
