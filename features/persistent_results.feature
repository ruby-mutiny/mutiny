Feature: Persistent results
  
  Scenario: Stores mutants
    Given I have the following program at "lib/max.rb":
      """
      class Max
        def run(left, right)
          max = left
          max = right if right > left
          max
        end
      end
      """
    And I have the following spec at "spec/max_spec.rb":
      """
      require_relative '../lib/max'
      
      describe Max do
        it "test1" do
          expect(Max.new.run(4, 4)).to eq(4)
        end
        it "test2" do
          expect(Max.new.run(4, 3)).to eq(4)
        end
        it "test3" do
          expect(Max.new.run(3, 4)).to eq(4)
        end
      end
      """
    When I configure mutiny with the option "results_file" set to the path "results.yaml"
    And I run mutiny on "spec/max_spec.rb"
    Then the file at "results.yaml" should contain the following mutants:
      | ID | Line | Change | Alive | Operator                                  |
      | 1  | 4    | <      | false | Mutiny::MutationOperators::BinaryOperator |
      | 2  | 4    | <=     | false | Mutiny::MutationOperators::BinaryOperator |
      | 3  | 4    | ==     | false | Mutiny::MutationOperators::BinaryOperator |
      | 4  | 4    | !=     | false | Mutiny::MutationOperators::BinaryOperator |
      | 5  | 4    | >=     | true  | Mutiny::MutationOperators::BinaryOperator |
    # Note that mutating > to >= produces an equivalent mutant
