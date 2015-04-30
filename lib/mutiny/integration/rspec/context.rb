require "rspec/core"
require "stringio"

module Mutiny
  class Integration
    class RSpec
      # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
      #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
      class Context
        # NB: the --fail-fast option can be used in order to find only the first failing test
        # CLI_OPTIONS = %w(spec --fail-fast)
        CLI_OPTIONS = %w(spec)

        attr_reader :runner, :world, :configuration, :output

        def initialize
          @output = StringIO.new
          @world  = ::RSpec.world
          @configuration = ::RSpec.configuration
          @runner = ::RSpec::Core::Runner.new(::RSpec::Core::ConfigurationOptions.new(CLI_OPTIONS))
          @runner.setup($stderr, @output)
        end
      end
    end
  end
end
