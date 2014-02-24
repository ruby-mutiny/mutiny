require_relative "../valuable/valuable"
require_relative "mutant"
require_relative "example"

module Mutiny
  class Result
    extend Valuable
    attributes :mutant, :example, :status
    
    attr_accessor :id
  end
end