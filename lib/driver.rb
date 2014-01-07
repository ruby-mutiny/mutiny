require_relative "mutiny"
require_relative "test"

EXAMPLE_DIR = ARGV[0]
program = File.read("#{EXAMPLE_DIR}/original.rb")
puts program

tests = Dir.glob("#{EXAMPLE_DIR}/test*.rb").each_with_index.map do |path, index|
  Test.new(index, File.read(path))
end

puts Mutiny.new(program, tests, noisy: true).run
