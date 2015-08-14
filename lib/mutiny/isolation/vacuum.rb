module Mutiny
  class Isolation
    # A mechanism for temporarily silencing a stream by redirecting
    # the output to the OS's null device (e.g., /dev/null)
    class Vacuum
      def self.silence(stream, &block)
        File.open(File::NULL, File::WRONLY) do |file|
          stream.reopen(file)
          block.call
        end
      end
    end
  end
end
