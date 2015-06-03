module Mutiny
  module Subjects
    describe Subject do
      context "relative_path" do
        it "should return path relative from root" do
          subject = Subject.new(name: "Foo::Bar::Baz", path: "/foo/bar/baz.rb", root: "/foo")

          expect(subject.relative_path).to eq("bar/baz.rb")
        end

        it "should return path relative from nested root" do
          subject = Subject.new(name: "Foo::Bar::Baz", path: "/foo/bar/baz.rb", root: "/foo/bar")

          expect(subject.relative_path).to eq("baz.rb")
        end

        it "should return path relative from root with trailing slash" do
          subject = Subject.new(name: "Foo::Bar::Baz", path: "/foo/bar/baz.rb", root: "/foo/")

          expect(subject.relative_path).to eq("bar/baz.rb")
        end
      end
    end
  end
end
