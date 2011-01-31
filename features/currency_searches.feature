@javascript
Feature: Currency Searches

  Background:
    Given there are these customers: 
      | Name             | Company  | Revenue | Business |
      | Adam Hawkins     | Radium   | 10000   | Sales    |
      | Shaun Densberger | Radium   | 500     | Support  |

  Scenario: The condition is more than
    Given I go to the home page
    When I select "Revenue" from "Attribute"
    And I select "More than" from "Operator"
    And I fill in "Value" with "$1,000"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Adam Hawkins     | Radium  |

  Scenario: The condition is less than
    Given I go to the home page
    When I select "Revenue" from "Attribute"
    And I select "Less than" from "Operator"
    And I fill in "Value" with "$1,000"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Shaun Densberger | Radium  |

  Scenario Outline: The conditions is a range
    Given I go to the home page
    When I select "Revenue" from "Attribute"
    And I select "Between" from "Operator"
    And I fill in "Value" with "<value>"
    And I select "Name" from "Sort by"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |

    Examples:
      | value               |
      | 50-25000            |
      | $50-$25000          |
      | $50-$25,0000        |
      | $50.55 - $25,000.35 |

  Scenario: The condition is equal to
    Given I go to the home page
    When I select "Revenue" from "Attribute"
    And I select "Is" from "Operator"
    And I fill in "Value" with "500"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Shaun Densberger | Radium  |

  Scenario: The condition is blank
    Given I go to the home page
    When I select "Revenue" from "Attribute"
    And I select "Is blank" from "Operator"
    And I press "Search"
    Then I should not see any customers

  Scenario: The revenue is not blank
    Given I go to the home page
    When I select "Revenue" from "Attribute"
    And I select "Is not blank" from "Operator"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |
