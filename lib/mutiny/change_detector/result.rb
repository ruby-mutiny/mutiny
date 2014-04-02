require "attributable"

module Mutiny
  module ChangeDetector
    class Result
      extend Attributable
      attributes :impacted_units, :impacted_specs
    end
  end
end
