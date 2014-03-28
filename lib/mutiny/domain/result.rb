require "attributable"
require_relative "mutant"
require_relative "example"

module Mutiny
  class Result
    extend Attributable
    attributes :mutant, :example, :status
  end
end
