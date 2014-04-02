require "attributable"
require "parser/current"
require_relative "executable"
require_relative "region"

module Mutiny
  class Unit
    include Executable

    extend Attributable
    attributes :path, region: Region::Everything.new
  end
end
