require "attributable"

module Mutiny
  class Example
    extend Attributable
    attributes :spec_path, :name, :line

    attr_accessor :id
  end
end