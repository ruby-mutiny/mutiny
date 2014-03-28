require "mutiny/rspec/suite_inspector"

module Mutiny
  module RSpec
    describe SuiteInspector, :include_file_system_helpers do
      before(:each) do
        clean_tmp_dir
      end

      it "should return a single spec when path is for a single spec file" do
        write("lib/calc.rb", calc_class)
        write("spec/calc_spec.rb", calc_spec)

        specs = SuiteInspector.new(path("spec/calc_spec.rb")).specs

        expect(specs.map(&:path)).to eq([path("spec/calc_spec.rb")])
        expect(specs.map(&:path_of_described_class)).to eq([path("lib/calc.rb")])
      end

      it "should return all specs when path is for a spec directory" do
        write("lib/calc.rb", calc_class)
        write("spec/calc_spec.rb", calc_spec)
        write("lib/nested/trig.rb", trig_class)
        write("spec/nested/trig_spec.rb", trig_spec)

        specs = SuiteInspector.new(path("spec")).specs

        expected_spec_paths = [path("spec/calc_spec.rb"), path("spec/nested/trig_spec.rb")]
        expect(specs.map(&:path)).to eq(expected_spec_paths)

        expected_unit_paths = [path("lib/calc.rb"), path("lib/nested/trig.rb")]
        expect(specs.map(&:path_of_described_class)).to eq(expected_unit_paths)
      end

      it "should return no specs when path is for an empty spec directory" do
        specs = SuiteInspector.new(path("spec")).specs

        expect(specs).to eq([])
      end

      def calc_spec
        """
        require_relative \"../lib/calc\"

        describe Calc do
          it \"adds\" do
            expect(Calc.new.add(2, 3)).to eq(4)
          end
        end
        """
      end

      def calc_class
        """
        class Calc
          def add(x, y)
            x + y
          end
        end
        """
      end

      def trig_spec
        """
        require_relative \"../../lib/nested/trig\"

        describe Trig do
          it \"sins\" do
            expect(Trig.new.sin(0)).to eq(0)
          end
        end
        """
      end

      def trig_class
        """
        class Trig
          def sin(x)
            Math.sin(x)
          end
        end
        """
      end
    end
  end
end
