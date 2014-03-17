Feature: Method-level mutation operators

  Scenario: Unary arithmetic operator replacement
    Given I have the following unit at "lib/life.rb":
      """
      class Life
        def run
          42
        end
      end
      """
    When I configure the mutator with the option "operator" set to "UAOR"
    And I run the mutator on "lib/life.rb"
    Then I should receive the following mutants:
      | Path        | Line | Change |
      | lib/life.rb | 3    | -      |

  Scenario: Binary arithmetic operator replacement
    Given I have the following unit at "lib/add.rb":
      """
      class Add
        def run(left, right)
          left + right
        end
      end
      """
    When I configure the mutator with the option "operator" set to "BAOR"
    And I run the mutator on "lib/add.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/add.rb | 3    | -      |
      | lib/add.rb | 3    | *      |
      | lib/add.rb | 3    | /      |
      | lib/add.rb | 3    | %      |

  Scenario: Relational operator replacement
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
    When I configure the mutator with the option "operator" set to "ROR"
    And I run the mutator on "lib/max.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/max.rb | 4    | <      |
      | lib/max.rb | 4    | <=     |
      | lib/max.rb | 4    | ==     |
      | lib/max.rb | 4    | !=     |
      | lib/max.rb | 4    | >=     |
  
  Scenario: Relational expression replacement
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
    When I configure the mutator with the option "operator" set to "RER"
    And I run the mutator on "lib/max.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/max.rb | 4    | true   |
      | lib/max.rb | 4    | false  |
  
  Scenario: Conditional operator replacement
    Given I have the following unit at "lib/xor.rb":
      """
      class Xor
        def run(left, right)
          left ^ right
        end
      end
      """
    When I configure the mutator with the option "operator" set to "COR"
    And I run the mutator on "lib/xor.rb"
    Then I should receive the following mutants:
      | Path       | Line | Change |
      | lib/xor.rb | 3    | &&     |
      | lib/xor.rb | 3    | \|\|   |
      | lib/xor.rb | 3    | and    |
      | lib/xor.rb | 3    | or     |

  Scenario: Shortcut assignment operator replacement
    Given I have the following unit at "lib/accumulate.rb":
      """
      class Accumulate
        def run(left, right)
          left += right
        end
      end
      """
    When I configure the mutator with the option "operator" set to "SAOR"
    And I run the mutator on "lib/accumulate.rb"
    Then I should receive the following mutants:
      | Path              | Line | Change |
      | lib/accumulate.rb | 3    | -=     |
      | lib/accumulate.rb | 3    | *=     |
      | lib/accumulate.rb | 3    | /=     |
      | lib/accumulate.rb | 3    | %=     |
      | lib/accumulate.rb | 3    | **=    |
      | lib/accumulate.rb | 3    | &=     |
      | lib/accumulate.rb | 3    | \|=    |
      | lib/accumulate.rb | 3    | ^=     |
      | lib/accumulate.rb | 3    | <<=    |
      | lib/accumulate.rb | 3    | >>=    |
      | lib/accumulate.rb | 3    | &&=    |
      | lib/accumulate.rb | 3    | \|\|=  |
      
  Scenario: Logical operator replacement (&, |, ^)
    Given I have the following unit at "lib/mask.rb":
      """
      class Mask
        def run(left, right)
          left | right
        end
      end
      """
    When I configure the mutator with the option "operator" set to "LOR"
    And I run the mutator on "lib/mask.rb"
    Then I should receive the following mutants:
      | Path        | Line | Change |
      | lib/mask.rb | 3    | &     |
      | lib/mask.rb | 3    | ^     |
