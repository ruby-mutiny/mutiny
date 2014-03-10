require_relative "store/yaml_store"
require_relative "store/mutant_mapper"
require_relative "store/example_mapper"
require_relative "store/result_mapper"
require_relative "store/typed_identity_map"

module Mutiny
  class Session < Struct.new(:path)
    def persist(mutants)
      @map = Mutiny::Store::TypedIdentityMap.new
      
      results = mutants.collect(&:results).flatten
      examples = results.collect(&:example).uniq { |example| [example.spec_path, example.line] }
      
      File.open(path, 'w') do |file|
        yaml_store = Mutiny::Store::YamlStore.new(file, :write_only)
        
        save_all(yaml_store, :mutants, mutants, serialise(mutants, Mutiny::Store::MutantMapper.new))
        save_all(yaml_store, :examples, examples, serialise(examples, Mutiny::Store::ExampleMapper.new))
        save_all(yaml_store, :results, results, serialise(results, Mutiny::Store::ResultMapper.new(@map)))
        
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