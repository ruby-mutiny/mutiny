require "json"

module Mutiny
  module RSpec
    class Sandbox
      # Executes the given block in a separate
      # process, and returns the result to this
      # parent process (via a JSON serialisation).
      def run(&block)
        reader, writer = IO.pipe

        fork do
          reader.close
          result = block.call
          writer.puts(result.to_json)
        end

        writer.close
        JSON.parse(reader.gets)
      end
    end
  end
end
