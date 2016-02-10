module Mutiny
  module Mutants
    class Storage
      describe MutantFileName do
        it "serialises mutant using subject's path and mutant's index" do
          expect(subject.serialise(mutant)).to eq(serialised_mutant)
        end

        it "deserialises subject's path and mutant's index" do
          expect(subject.deserialise(serialised_mutant)).to eq(deserialised_mutant)
        end

        def mutant
          Mutant.new(subject: subject_of_mutation, code: "2 - 2", index: 0, mutation_name: "BAOR")
        end

        def subject_of_mutation
          Subjects::Subject.new(name: "Two", path: "~/Code/sums/two.rb", root: "~/Code/sums")
        end

        def serialised_mutant
          "two.0.rb"
        end

        def deserialised_mutant
          {
            subject: { path: "two.rb" },
            index: 0
          }
        end
      end
    end
  end
end
