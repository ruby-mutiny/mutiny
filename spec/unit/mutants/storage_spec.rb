module Mutiny
  module Mutants
    describe Storage do
      it "transforms hashes to mutants and subjects" do
        store = instance_double(Storage::FileStore)
        allow(store).to receive(:load_all).and_return(loaded_data)

        first_subject  = Subjects::Subject.new(name: "Two", path: "two.rb", root: ".")
        second_subject = Subjects::Subject.new(name: "Four", path: "four.rb", root: ".")
        subjects = Subjects::SubjectSet.new([first_subject, second_subject])

        expected_mutant_set = MutantSet.new(
          Mutant.new(subject: first_subject, code: "2 - 2", index: 0),
          Mutant.new(subject: first_subject, code: "2 * 2", index: 1),
          Mutant.new(subject: second_subject, code: "4 - 4", index: 2)
        )

        storage = Storage.new(store: store)
        expect(storage.load_for(subjects)).to eq(expected_mutant_set)
      end

      # rubocop:disable MethodLength
      def loaded_data
        [
          {
            subject: { name: "Two", path: "two.rb" },
            code: "2 - 2",
            index: 0
          },
          {
            subject: { name: "Two", path: "two.rb" },
            code: "2 * 2",
            index: 1
          },
          {
            subject: { name: "Four", path: "four.rb" },
            code: "4 - 4",
            index: 0
          }
        ]
      end
      # rubocop:enable MethodLength
    end
  end
end
