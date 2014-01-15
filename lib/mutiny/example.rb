require "mutiny/attributable"

module Mutiny
  class Example
    extend Attributable
    
    attributes :id, :spec_path, :name
  end
end