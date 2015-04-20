# Based on RSpec-Core's spec/spec_helper

# Allows us to run our RSpecs in a sandbox in which
# they are free to modify the RSpec world / configuration.
# This is necessary as some of Mutiny's classes run specs,
# and hence pollute the RSpec.world and RSpec.configuration
# variables.

module Sandboxing
  # rubocop:disable MethodLength
  # rubocop:disable AbcSize
  def self.sandboxed(&block)
    @orig_config = RSpec.configuration
    @orig_world  = RSpec.world
    new_config = RSpec::Core::Configuration.new
    new_world  = RSpec::Core::World.new(new_config)
    RSpec.configuration = new_config
    RSpec.world = new_world
    object = Object.new
    object.extend(RSpec::Core::SharedExampleGroup)

    (class << RSpec::Core::ExampleGroup; self; end).class_eval do
      alias_method :orig_run, :run
      def run(reporter = nil)
        orig_run(reporter || NullObject.new)
      end
    end

    object.instance_eval(&block)
  ensure
    (class << RSpec::Core::ExampleGroup; self; end).class_eval do
      remove_method :run
      alias_method :run, :orig_run
      remove_method :orig_run
    end

    RSpec.configuration = @orig_config
    RSpec.world = @orig_world
  end
  # rubocop:enable MethodLength
  # rubocop:enable AbcSize
end
