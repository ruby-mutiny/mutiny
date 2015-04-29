require_relative "mode/check"

module Mutiny
  class Mode
    attr_reader :configuration, :environment

    def initialize(configuration)
      @configuration = configuration
      @environment = Subjects::Environment.new(configuration)
    end

    private

    def report(message)
      configuration.reporter.report(message)
    end
  end
end
