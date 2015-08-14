module Mutiny
  class Isolation
    # An inter-process communication mechanism for sending and receiving
    # (marshalled) data over an IO pipe
    Pipe = Struct.new(:reader, :writer) do
      def self.with(&block)
        # IO.pipe(binmode: true) do |reader, writer|
        #   writer.binmode
        #   block.call(Pipe.new(reader, writer))
        # end
        IO.pipe { |reader, writer| block.call(Pipe.new(reader, writer)) }
      end

      def receive
        writer.close
        Marshal.load(reader.read)
      end

      def send(data)
        reader.close
        writer.write(Marshal.dump(data))
        writer.close
      end
    end
  end
end
