require_relative "store/yaml_store"
require_relative "store/mutant_mapper"

module Mutiny
  class Session < Struct.new(:path)
    def persist(mutants)
      File.open(path, 'w') do |file|
        yaml_store = Mutiny::Store::YamlStore.new(file)
        yaml_store.save_all(:mutants, serialise(mutants))
        yaml_store.finalise(file)
      end
    end
    
  private
    def serialise(mutants)
      mapper = Mutiny::Store::MutantMapper.new
      mutants.collect { |mutant| mapper.serialise(mutant) }
    end
  end
end