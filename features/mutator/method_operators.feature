Feature: Method-level mutation operators

  Scenario: Unary arithmetic operator deletion
    Given I have the following program:
      """
      [-42, -a]
      """
    When I apply the mutation operator "UAOD"
    Then I should receive the following mutated code:
      """
      [42, -a]
      [-42, a]
      """

  Scenario: Unary arithmetic operator insertion
    Given I have the following program:
      """
      [42, a]
      """
    When I apply the mutation operator "UAOI"
    Then I should receive the following mutated code:
      """
      [-42, a]
      [42, -a]
      """
  
  Scenario: Binary arithmetic operator replacement on variable
    Given I have the following program:
      """
      a + 10
      """
    When I apply the mutation operator "BAOR"
    Then I should receive the following mutated code:
      """
      a - 10
      a * 10
      a / 10
      a % 10
      """
      
  Scenario: Binary arithmetic operator replacement on literal
    Given I have the following program:
      """
      10 + a
      """
    When I apply the mutation operator "BAOR"
    Then I should receive the following mutated code:
      """
      10 - a
      10 * a
      10 / a
      10 % a
      """
  
  Scenario: Relational operator replacement on variable
    Given I have the following program:
      """
      a > 10
      """
    When I apply the mutation operator "ROR"
    Then I should receive the following mutated code:
      """
      a < 10
      a <= 10
      a == 10
      a != 10
      a >= 10
      """
  
  Scenario: Relational operator replacement on literal
    Given I have the following program:
      """
      10 > a
      """
    When I apply the mutation operator "ROR"
    Then I should receive the following mutated code:
      """
      10 < a
      10 <= a
      10 == a
      10 != a
      10 >= a
      """
  
  Scenario: Relational expression replacement
    Given I have the following program:
      """
      [a > 10, 10 < a]
      """
    When I apply the mutation operator "RER"
    Then I should receive the following mutated code:
      """
      [true, 10 < a]
      [false, 10 < a]
      [a > 10, true]
      [a > 10, false]
      """

  Scenario: Conditional operator replacement on literal
    Given I have the following program:
      """
      a ^ true
      """
    When I apply the mutation operator "COR"
    Then I should receive the following mutated code:
      """
      a && true
      a || true
      """
      
  Scenario: Conditional operator replacement on variable
    Given I have the following program:
      """
      true ^ a
      """
    When I apply the mutation operator "COR"
    Then I should receive the following mutated code:
      """
      true && a
      true || a
      """

  # blocked behind https://github.com/mbj/unparser/issues/26
  @wip
  Scenario: Conditional operator replacement in full
    Given I have the following program:
      """
      a ^ b and c
      """
    When I apply the mutation operator "COR"
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
    Given I have the following program:
      """
      [!a, !true]
      """
    When I apply the mutation operator "COD"
    Then I should receive the following mutated code:
      """
      [a, !true]
      [!a, true]
      """
  
  Scenario: Conditional operator insertion
    Given I have the following program:
      """
      [a, true]
      """
    When I apply the mutation operator "COI"
    Then I should receive the following mutated code:
      """
      [!a, true]
      [a, !true]
      """
  
  Scenario: Shortcut assignment operator replacement on variable
    Given I have the following program:
      """
      a += b
      """
    When I apply the mutation operator "SAOR"
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
  
  Scenario: Shortcut assignment operator replacement on literal
    Given I have the following program:
      """
      a += 10
      """
    When I apply the mutation operator "SAOR"
    Then I should receive the following mutated code:
      """
      a -= 10
      a *= 10
      a /= 10
      a %= 10
      a **= 10
      a &= 10
      a |= 10
      a ^= 10
      a <<= 10
      a >>= 10
      a &&= 10
      a ||= 10
      """
 
  Scenario: Logical operator replacement on variable
    Given I have the following program:
      """
      a | 10
      """
    When I apply the mutation operator "LOR"
    Then I should receive the following mutated code:
      """
      a & 10
      a ^ 10
      """

  Scenario: Logical operator replacement on literal
    Given I have the following program:
      """
      10 | a
      """
    When I apply the mutation operator "LOR"
    Then I should receive the following mutated code:
      """
      10 & a
      10 ^ a
      """

  Scenario: Logical operator deletion
    Given I have the following program:
      """
      [~a, ~10]
      """
    When I apply the mutation operator "LOD"
    Then I should receive the following mutated code:
      """
      [a, ~10]
      [~a, 10]
      """

  Scenario: Logical operator insertion
    Given I have the following program:
      """
      [a, 10]
      """
    When I apply the mutation operator "LOI"
    Then I should receive the following mutated code:
      """
      [~a, 10]
      [a, ~10]
      """