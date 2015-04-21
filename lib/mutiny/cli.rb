require_relative "configuration"
require_relative "environment"
require_relative "cli/check"

module Mutiny
  class CLI
    def self.run(arguments)
      configuration = Configuration.new(arguments[1], arguments[2], arguments[3])
      environment = Environment.new(configuration)
      Check.run(environment)
    end
  end
end
