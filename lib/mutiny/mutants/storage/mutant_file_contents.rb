module Mutiny
  module Mutants
    class Storage
      class MutantFileContents
        def serialise(mutant)
          "# " + mutant.subject.name + "\n" \
          "# " + mutant.mutation_name + "\n" \
          "# " + mutant.location.position.to_s + "\n" +
            mutant.code
        end

        def deserialise(contents)
          {
            subject: { name: extract_contents_of_comment(contents.lines[0]) },
            mutation_name: extract_contents_of_comment(contents.lines[1]),
            position: convert_to_range(extract_contents_of_comment(contents.lines[2])),
            code: contents.lines.drop(3).join
          }
        end

        private

        def extract_contents_of_comment(line)
          line[2..-1].strip
        end

        def convert_to_range(string)
          Range.new(*string.split("..").map(&:to_i))
        end
      end
    end
  end
end
