require_relative "../../spec/helpers/file_system"
World(Helpers::FileSystem)

Before do
  clean_tmp_dir
  
  # Ensure that specs loaded as part of evaluating any
  # previous scenario are discared
  RSpec.world.reset
end