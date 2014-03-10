require "attributable"
require_relative "executable"

module Mutiny
  class Unit
    include Executable
    
    extend Attributable
    attributes :path
  end
end