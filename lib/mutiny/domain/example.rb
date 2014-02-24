require_relative "../valuable/valuable"

module Mutiny
  class Example
    extend Valuable
    attributes :spec_path, :name, :line

    attr_accessor :id
  end
end