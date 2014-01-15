require "mutiny/attributable"

module Mutiny
  class Result
    extend Attributable
    
    attributes :mutant, :example, :status
  end
end