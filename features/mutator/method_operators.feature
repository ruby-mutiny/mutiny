Feature: Method-level mutation operators

  Scenario: Unary arithmetic operator deletion
    Given I have the following unit at "lib/life.rb":
      """
      -42
      """
    When I configure the mutator with the option "operator" set to "UAOD"
    And I run the mutator on "lib/life.rb"
    Then I should receive the following mutated code:
      """
      42
      """

  Scenario: Unary arithmetic operator insertion
    Given I have the following unit at "lib/life.rb":
      """
      42
      """
    When I configure the mutator with the option "operator" set to "UAOI"
    And I run the mutator on "lib/life.rb"
    Then I should receive the following mutated code:
      """
      -42
      """
  
  Scenario: Unary arithmetic operator replacement
    Given I have the following unit at "lib/life.rb":
      """
      42 + -42
      """
    When I configure the mutator with the option "operator" set to "UAOR"
    And I run the mutator on "lib/life.rb"
    Then I should receive the following mutated code:
      """
      (-42) + (-42)
      42 + 42
      """
  
  Scenario: Binary arithmetic operator replacement
    Given I have the following unit at "lib/add.rb":
      """
      a + 10
      """
    When I configure the mutator with the option "operator" set to "BAOR"
    And I run the mutator on "lib/add.rb"
    Then I should receive the following mutated code:
      """
      a - 10
      a * 10
      a / 10
      a % 10
      """
  
  Scenario: Relational operator replacement
    Given I have the following unit at "lib/max.rb":
      """
      a > 10
      """
    When I configure the mutator with the option "operator" set to "ROR"
    And I run the mutator on "lib/max.rb"
    Then I should receive the following mutated code:
      """
      a < 10
      a <= 10
      a == 10
      a != 10
      a >= 10
      """
  
  Scenario: Relational expression replacement
    Given I have the following unit at "lib/max.rb":
      """
      a > 10
      """
    When I configure the mutator with the option "operator" set to "RER"
    And I run the mutator on "lib/max.rb"
    Then I should receive the following mutated code:
      """
      true
      false
      """

  Scenario: Conditional operator replacement
    Given I have the following unit at "lib/xor.rb":
      """
      a ^ b
      """
    When I configure the mutator with the option "operator" set to "COR"
    And I run the mutator on "lib/xor.rb"
    Then I should receive the following mutated code:
      """
      a && b
      a || b
      """

  # blocked behind https://github.com/mbj/unparser/issues/26
  @wip
  Scenario: Conditional operator replacement in full
    Given I have the following unit at "lib/xor.rb":
      """
      a ^ b and c
      """
    When I configure the mutator with the option "operator" set to "COR"
    And I run the mutator on "lib/xor.rb"
    Then I should receive the following mutated code:
      """
      a && b and c
      a || b and c
      a and b and c
      a or b and c
      a ^ b ^ c
      a ^ b && c
      a ^ b || c
      a ^ b or c
      """

  Scenario: Conditional operator deletion
    Given I have the following unit at "lib/inverter.rb":
      """
      !a
      """
    When I configure the mutator with the option "operator" set to "COD"
    And I run the mutator on "lib/inverter.rb"
    Then I should receive the following mutated code:
      """
      a
      """
  
  Scenario: Conditional operator insertion
    Given I have the following unit at "lib/identity.rb":
      """
      a
      """
    When I configure the mutator with the option "operator" set to "COI"
    And I run the mutator on "lib/identity.rb"
    Then I should receive the following mutated code:
      """
      !a
      """
  
  Scenario: Shortcut assignment operator replacement
    Given I have the following unit at "lib/accumulate.rb":
      """
      a += b
      """
    When I configure the mutator with the option "operator" set to "SAOR"
    And I run the mutator on "lib/accumulate.rb"
    Then I should receive the following mutated code:
      """
      a -= b
      a *= b
      a /= b
      a %= b
      a **= b
      a &= b
      a |= b
      a ^= b
      a <<= b
      a >>= b
      a &&= b
      a ||= b
      """
  
  Scenario: Logical operator replacement
    Given I have the following unit at "lib/mask.rb":
      """
      a | b
      """
    When I configure the mutator with the option "operator" set to "LOR"
    And I run the mutator on "lib/mask.rb"
    Then I should receive the following mutated code:
      """
      a & b
      a ^ b
      """

  Scenario: Logical operator deletion
    Given I have the following unit at "lib/bitwise_not.rb":
      """
      ~a
      """
    When I configure the mutator with the option "operator" set to "LOD"
    And I run the mutator on "lib/bitwise_not.rb"
    Then I should receive the following mutated code:
      """
      a
      """

  Scenario: Logical operator insertion
    Given I have the following unit at "lib/identity.rb":
      """
      a
      """
    When I configure the mutator with the option "operator" set to "LOI"
    And I run the mutator on "lib/identity.rb"
    Then I should receive the following mutated code:
      """
      ~a
      """