require "attributable"

module Mutiny
  class Example
    extend Attributable
    attributes :spec_path, :name, :line
  end
end