module Mutiny
  module Subjects
    describe SubjectSet do
      context "per_file" do
        it "should contain only the alphabetically first subject when more than one in a file" do
          first = Subject.new(name: "Bar", path: "main.rb")
          second = Subject.new(name: "Foo", path: "main.rb")
          nested = Subject.new(name: "Foo::Bar", path: "main.rb")

          all_subjects = SubjectSet.new([first, second, nested])

          expect(all_subjects.per_file).to eq(SubjectSet.new([first]))
        end

        it "should contain all subjects when there are one-per-file" do
          first = Subject.new(name: "Bar", path: "bar.rb")
          second = Subject.new(name: "Foo", path: "foo.rb")
          nested = Subject.new(name: "Foo::Bar", path: "foo/bar.rb")

          all_subjects = SubjectSet.new([first, second, nested])

          expect(all_subjects.per_file).to eq(all_subjects)
        end
      end
    end
  end
end
