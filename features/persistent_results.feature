Feature: Persistent results
  
  Scenario: Stores mutants
    Given I have the following unit at "lib/max.rb":
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
    When I configure mutiny with "results_file" set to the path "results.yaml"
    And I run mutiny on "spec/max_spec.rb"
    Then the file at "results.yaml" should contain the following examples:
      | ID | Line | Spec Path        | Name  |
      | 1  | 4    | spec/max_spec.rb | test1 |
      | 2  | 7    | spec/max_spec.rb | test2 |
      | 3  | 10   | spec/max_spec.rb | test3 |
    And  the file at "results.yaml" should contain the following results:
      | ID | Mutant ID | Example ID | Status |
      | 1  | 1         | 1          | passed |
      | 2  | 1         | 2          | failed |
      | 3  | 1         | 3          | failed |
      | 4  | 2         | 1          | passed |
      | 5  | 2         | 2          | failed |
      | 6  | 2         | 3          | failed |
      | 7  | 3         | 1          | passed |
      | 8  | 3         | 2          | passed |
      | 9  | 3         | 3          | failed |
      | 10 | 4         | 1          | passed |
      | 11 | 4         | 2          | failed |
      | 12 | 4         | 3          | passed |
      | 13 | 5         | 1          | passed |
      | 14 | 5         | 2          | passed |
      | 15 | 5         | 3          | passed |
    And the file at "results.yaml" should contain the following mutants:
      | ID | Path       | Line | Change | Alive? | Operator                                                          |
      | 1  | lib/max.rb | 4    | <      | false  | Mutiny::Mutator::MutationOperators::RelationalOperatorReplacement |
      | 2  | lib/max.rb | 4    | <=     | false  | Mutiny::Mutator::MutationOperators::RelationalOperatorReplacement |
      | 3  | lib/max.rb | 4    | ==     | false  | Mutiny::Mutator::MutationOperators::RelationalOperatorReplacement |
      | 4  | lib/max.rb | 4    | !=     | false  | Mutiny::Mutator::MutationOperators::RelationalOperatorReplacement |
      | 5  | lib/max.rb | 4    | >=     | true   | Mutiny::Mutator::MutationOperators::RelationalOperatorReplacement |
    # Note that mutating > to >= produces an equivalent mutant
