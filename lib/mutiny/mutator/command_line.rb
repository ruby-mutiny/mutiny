require "attributable"

module Mutiny
  module Mutator
    class CommandLine
      extend Attributable
      attributes :path
  
      def run
        []
      end
    
    private
    end
  end
end