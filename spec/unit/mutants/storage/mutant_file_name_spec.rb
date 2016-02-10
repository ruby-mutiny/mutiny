module Mutiny
  module Mutants
    class Storage
      describe MutantFileName do
        it "serialises" do
          expect(subject.serialise(mutant)).to eq(serialised_mutant)
        end

        it "deserialises" do
          expect(subject.deserialise(serialised_mutant)).to eq(deserialised_mutant)
        end

        def mutant
          Mutant.new(subject: subject_of_mutation, code: "2 - 2", index: 10, mutation_name: "BAOR")
        end

        def subject_of_mutation
          Subjects::Subject.new(name: "Two", path: "~/Code/sums/two.rb", root: "~/Code/sums")
        end

        def serialised_mutant
          "two.10.rb"
        end

        def deserialised_mutant
          {
            subject: { path: "two.rb" },
            index: 10
          }
        end
      end
    end
  end
end
