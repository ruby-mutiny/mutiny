module Mutiny
  module Subjects
    class Environment
      describe Type do
        context "relevance" do
          it "should include named class that are in scope and that are on the load path" do
            configuration = Configuration.new(patterns: ["*"], loads: ["spec"])
            type = Type.new(Person, configuration)

            expect(type.relevant?).to be_truthy
          end

          it "should exclude anonymous classes" do
            type = Type.new(Class.new, Configuration.new(patterns: ["*"], loads: ["spec"]))

            expect(type.relevant?).to be_falsey
          end

          it "should exclude classes that are not in scope" do
            configuration = Configuration.new(patterns: ["Department"], loads: ["spec"])
            type = Type.new(Person, configuration)

            expect(type.relevant?).to be_falsey
          end

          it "should exclude classes that are not on the load path" do
            configuration = Configuration.new(patterns: ["*"], loads: ["lib"])
            type = Type.new(Person, configuration)

            expect(type.relevant?).to be_falsey
          end
        end

        context "to_subject" do
          it "should build a valid subject" do
            configuration = Configuration.new(patterns: ["*"], loads: ["spec"])
            type = Type.new(Person, configuration)
            expected_subject = Subject.new(
              name: "Mutiny::Subjects::Environment::Person",
              path: __FILE__,
              root: __FILE__.match(%r{.*/spec})[0]
            )

            expect(type.to_subject).to eq(expected_subject)
          end
        end

        class Person
          attr_accessor :name
        end
      end
    end
  end
end
