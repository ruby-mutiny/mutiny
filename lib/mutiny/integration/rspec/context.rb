require "rspec/core"
require "stringio"

module Mutiny
  class Integration
    class RSpec < self
      # This code originally based on Markus Schirp's implementation of Mutant::Integration::Rspec
      #  https://github.com/mbj/mutant/blob/master/lib/mutant/integration/rspec.rb
      class Context
        DEFAULT_CLI_OPTIONS = %w(spec)
        FAIL_FAST_CLI_OPTION = %w(--fail-fast)

        attr_reader :runner, :world, :configuration, :output

        def initialize(options = {})
          @options = options
          @output = StringIO.new
          @world  = ::RSpec.world
          @configuration = ::RSpec.configuration
          @runner = ::RSpec::Core::Runner.new(::RSpec::Core::ConfigurationOptions.new(cli_options))
          @runner.setup($stderr, @output)
        end

        def cli_options
          if @options.fetch(:fail_fast, false)
            DEFAULT_CLI_OPTIONS + FAIL_FAST_CLI_OPTION
          else
            DEFAULT_CLI_OPTIONS
          end
        end
      end
    end
  end
end
