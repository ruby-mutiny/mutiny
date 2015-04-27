require_relative "command/check"

module Mutiny
  class Command
    attr_reader :configuration, :environment

    def initialize(configuration)
      @configuration = configuration
      @environment = Environment.new(configuration)
    end

    private

    def report(message)
      configuration.reporter.report(message)
    end
  end
end
