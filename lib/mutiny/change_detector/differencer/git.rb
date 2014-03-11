require "attributable"
require "git"

module Mutiny
  module ChangeDetector
    module Differencer
      class Git
        extend Attributable
        attributes :path, :start_label, :finish_label
        
        def changed_paths
          ::Git.open(path).diff(finish_label, start_label).map(&:path)
        end
      end
    end
  end
end