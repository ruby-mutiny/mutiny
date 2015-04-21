module Mutiny
  class Configuration
    attr_reader :load_paths, :requires, :patterns

    def initialize(load_path, req, pattern)
      @load_paths = [load_path]
      @requires = [req]
      @patterns = [pattern]
    end
  end
end
