@javascript
Feature: String Searches

  Background:
    Given there are these customers: 
      | Name             | Company  | State |
      | Adam Hawkins     | Radium   | client |
      | Shaun Densberger | Radium   | prospect |

  Scenario: The condition is equal to
    Given I go to the home page
    When I select "Kind" from "Attribute"
    And I select "Is" from "Operator"
    And I select "Prospect" from "Choice"
    And I press "Search"
    Then I should see the following customer:
      | Name            | Company |
      | Shaun Densberger | Radium  |

  Scenario: The condition is blank
    Given I go to the home page
    When I select "Kind" from "Attribute"
    And I select "Is blank" from "Operator"
    And I press "Search"
    Then I should not see any customers

  Scenario: The condition is not blank
    Given I go to the home page
    When I select "Kind" from "Attribute"
    And I select "Is not blank" from "Operator"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |
