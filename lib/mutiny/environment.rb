module Mutiny
  class Environment
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      setup
    end

    def subjects
      ObjectSpace.each_object(Module).select do |mod|
        !mod.name.nil? && configuration.patterns.any? { |pattern| mod.name.start_with?(pattern) }
      end
    end

    private

    def setup
      configuration.loads.each { |l| $LOAD_PATH << l }
      configuration.requires.each { |r| require r }
    end
  end
end
