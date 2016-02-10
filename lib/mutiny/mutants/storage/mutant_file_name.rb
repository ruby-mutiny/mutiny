module Mutiny
  module Mutants
    class Storage
      class MutantFileName
        def serialise(mutant)
          path_with_index(mutant.subject.relative_path, mutant.index)
        end

        def deserialise(path)
          {
            subject: { path: path_without_index(path) },
            index: index_of(path)
          }
        end

        private

        def path_with_index(path, index)
          path.sub(/\.rb$/, ".#{index}.rb")
        end

        def path_without_index(path)
          path.sub(/\.\d+\.rb$/, ".rb")
        end

        def index_of(path)
          path.match(/.*\.(\d+)\.rb/)[1].to_i
        end
      end
    end
  end
end
