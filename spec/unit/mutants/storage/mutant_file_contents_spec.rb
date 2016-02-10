module Mutiny
  module Mutants
    class Storage
      describe MutantFileContents do
        it "serialises mutant's code and its metadata" do
          expect(subject.serialise(mutant)).to eq(serialised_mutant)
        end

        it "deserialises mutant's code, mutation name and subject name" do
          expect(subject.deserialise(serialised_mutant)).to eq(deserialised_mutant)
        end

        def mutant
          Mutant.new(subject: subject_of_mutation, code: "2 - 2", index: 0, mutation_name: "BAOR")
        end

        def subject_of_mutation
          Subjects::Subject.new(name: "Two", path: "~/Code/sums/two.rb", root: "~/Code/sums")
        end

        def serialised_mutant
          "# Two\n"  \
          "# BAOR\n" \
          "2 - 2"
        end

        def deserialised_mutant
          {
            subject: { name: "Two" },
            mutation_name: "BAOR",
            code: "2 - 2"
          }
        end
      end
    end
  end
end
