require "mutiny/integration/hook"

module Mutiny
  class Integration
    describe RSpec do
      let(:test_set) { subject.tests }

      it "should call hooks before each spec" do
        in_example_project("calculator") do
          hook = TestHook.new
          subject.run(test_set, hooks: [hook])

          expect(hook.examples_started.size).to eq(test_set.size)
        end
      end

      it "should call hooks after each spec" do
        in_example_project("calculator") do
          hook = TestHook.new
          subject.run(test_set, hooks: [hook])

          expect(hook.examples_finished.size).to eq(test_set.size)
        end
      end

      class TestHook < Hook
        def before(example)
          examples_started << example
        end

        def after(example)
          examples_finished << example
        end

        def examples_started
          @examples_started ||= []
        end

        def examples_finished
          @examples_finished ||= []
        end
      end
    end
  end
end
