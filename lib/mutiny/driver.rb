require_relative "command_line"
require_relative "mutator/command_line"

mode = ARGV[0]

if mode == "mutate"
  mutants = Mutiny::Mutator::CommandLine.new(path: ARGV[1], operator: "*", noisy: true).run

  mutants.each do |mutant|
    puts "#{mutant.operator}(#{mutant.change}) at #{mutant.path}@#{mutant.position}"
  end

else
  test_suite_path = ARGV[0]
  puts "Test suite path: #{test_suite_path}"

  puts Mutiny::CommandLine.new(test_suite_path, noisy: true).run
end
