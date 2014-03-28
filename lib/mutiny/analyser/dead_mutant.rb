module Mutiny
  module Analyser
    module DeadMutant
      def killed?
        true
      end

      def alive?
        false
      end
    end
  end
end
