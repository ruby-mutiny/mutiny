require_relative "store/yaml_store"
require_relative "store/mutant_mapper"
require_relative "store/example_mapper"
require_relative "store/result_mapper"
require_relative "store/typed_identity_map"

module Mutiny
  class Session < Struct.new(:path)
    def persist(analysis)
      @map = Mutiny::Store::TypedIdentityMap.new
      
      File.open(path, 'w') do |file|
        yaml_store = Mutiny::Store::YamlStore.new(file, :write_only)
        
        save_all(yaml_store, :mutants, analysis.mutants, serialise(analysis.mutants, Mutiny::Store::MutantMapper.new))
        save_all(yaml_store, :examples, analysis.examples, serialise(analysis.examples, Mutiny::Store::ExampleMapper.new))
        save_all(yaml_store, :results, analysis.results, serialise(analysis.results, Mutiny::Store::ResultMapper.new(@map)))
        
        yaml_store.finalise(file)
      end
    end
    
  private
    def serialise(objects, mapper)
      objects.collect { |object| mapper.serialise(object) }
    end
    
    def save_all(store, key, in_memory_objects, serialised_objects)
      ids = store.save_all(key, serialised_objects)
      in_memory_objects.zip(ids).each { |object, id| @map.put(singularize(key), id, object) }
    end
    
    def singularize(key)
      key.to_s[0..-2].to_sym
    end
  end
end