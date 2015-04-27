module Mutiny
  module Reporter
    class Stdout
      def report(message)
        puts message
      end
    end
  end
end
