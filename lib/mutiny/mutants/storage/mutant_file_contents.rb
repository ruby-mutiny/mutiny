module Mutiny
  module Mutants
    class Storage
      class MutantFileContents
        def serialise(mutant)
          "# " + mutant.subject.name + "\n" \
          "# " + mutant.mutation_name + "\n" +
            mutant.code
        end

        def deserialise(contents)
          {
            subject: { name: extract_contents_of_comment(contents.lines[0]) },
            mutation_name: extract_contents_of_comment(contents.lines[1]),
            code: contents.lines.drop(2).join
          }
        end

        private

        def extract_contents_of_comment(line)
          line[2..-1].strip
        end
      end
    end
  end
end
