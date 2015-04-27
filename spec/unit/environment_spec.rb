module Mutiny
  describe Environment do
    context "initialization" do
      it "should add the required class and all dependences to available modules" do
        in_sub_process do
          configuration = Configuration.new(
            loads: ["examples/calculator/lib"],
            requires: ["calculator"]
          )

          expect { Environment.new(configuration) }
            .to change { Environment.modules.map(&:name).reject(&:nil?).sort }
            .by(%w(Calculator Calculator::Max))
        end
      end

      it "should not add any classes without a require" do
        in_sub_process do
          configuration = Configuration.new(
            loads: ["examples/calculator/lib/calculator"]
          )

          expect { Environment.new(configuration) }
            .not_to change { Environment.modules.map(&:name) }
        end
      end

      it "should raise when require not found" do
        in_sub_process do
          configuration = Configuration.new(
            requires: ["calculator"]
          )

          expect { Environment.new(configuration) }
            .to raise_error(LoadError)
        end
      end
    end

    context "subjects" do
      let(:configuration) do
        Configuration.new(
          loads: ["examples/calculator/lib"],
          requires: ["calculator"],
          patterns: ["Calculator"]
        )
      end

      let(:environment) { Environment.new(configuration) }

      it "should return all subjects matching pattern" do
        in_sub_process do
          expect(environment.subjects.map(&:name).sort).to eq(%w(Calculator Calculator::Max))
        end
      end

      it "should function in the presence of anonymous modules" do
        in_sub_process do
          Class.new   # create anonymous class
          expect(environment.subjects.map(&:name).sort).to eq(%w(Calculator Calculator::Max))
        end
      end
    end
  end
end
