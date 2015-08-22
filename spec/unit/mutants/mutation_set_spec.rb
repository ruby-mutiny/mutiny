module Mutiny
  module Mutants
    describe MutationSet do
      it "produces one mutant for each result of mutation.mutate_file" do
        mutation_set = MutationSet.new(mutation_for(:code1, :code2, :code3))
        subjects = subjects_for(:path1)

        expected = MutantSet.new(
          Mutant.new(subject: subjects.first, code: :code1),
          Mutant.new(subject: subjects.first, code: :code2),
          Mutant.new(subject: subjects.first, code: :code3)
        )

        expect(mutation_set.mutate(subjects)).to eq(expected)
      end

      it "produces mutants from each mutation" do
        mutation_set = MutationSet.new(mutation_for(:code1), mutation_for(:code2))
        subjects = subjects_for(:path1)

        expected = MutantSet.new(
          Mutant.new(subject: subjects.first, code: :code1),
          Mutant.new(subject: subjects.first, code: :code2)
        )

        expect(mutation_set.mutate(subjects)).to eq(expected)
      end

      it "produces mutants for each subject" do
        mutation_set = MutationSet.new(mutation_for(:code1, :code2), mutation_for(:code3))
        subjects = subjects_for(:path1, :path2)

        expected = MutantSet.new(
          Mutant.new(subject: subjects.first, code: :code1),
          Mutant.new(subject: subjects.first, code: :code2),
          Mutant.new(subject: subjects.first, code: :code3),
          Mutant.new(subject: subjects.last, code: :code1),
          Mutant.new(subject: subjects.last, code: :code2),
          Mutant.new(subject: subjects.last, code: :code3)
        )

        expect(mutation_set.mutate(subjects)).to eq(expected)
      end

      it "produces a mutiny error when mutation fails" do
        mutation = instance_double(Mutation)
        allow(mutation).to receive(:name) { "BuggyMutation" }
        allow(mutation).to receive(:mutate_file).and_raise("boom")
        mutation_set = MutationSet.new(mutation)
        subjects = subjects_for(:path1)

        expect { mutation_set.mutate(subjects) }.to raise_error do |error|
          expected_message = "Error encountered whilst mutating file at 'path1' with BuggyMutation"

          expect(error).to be_a(Mutation::Error)
          expect(error.message).to eq(expected_message)
          expect(error.cause.message).to eq("boom")
        end
      end

      def mutation_for(*codes)
        double.tap do |mutation|
          allow(mutation).to receive(:mutate_file) { codes }
        end
      end

      def subjects_for(*paths)
        paths.map { |path| subject_for(path) }
      end

      def subject_for(path)
        double.tap do |subject|
          allow(subject).to receive(:path) { path }
        end
      end
    end
  end
end
