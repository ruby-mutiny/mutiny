require "parser/current"
require_relative "executable"
require_relative "region"

module Mutiny
  class Unit < Executable
    attributes :path, region: Region::Everything.new
  end
end
