@javascript
Feature: Boolean Conditions

  Background:
    Given there are these customers: 
      | Name             | Company  | State | 
      | Adam Hawkins     | Radium   | client |
      | Shaun Densberger | Radium   | prospect |

  Scenario: The condition is equal to
    Given I go to the home page
    And "Adam Hawkins" has not bought products
    And "Shaun Densberger" has bought products
    When I select "Bought Products" from "Attribute"
    And I select "Is" from "Operator"
    And I select "Yes" from "Choice"
    And I press "Search"
    Then I should see the following customer:
      | Name            | Company |
      | Shaun Densberger | Radium  |

  Scenario: The condition is not equal to
    Given I go to the home page
    And "Adam Hawkins" has not bought products
    And "Shaun Densberger" has bought products
    When I select "Bought Products" from "Attribute"
    And I select "Is" from "Operator"
    And I select "No" from "Choice"
    And I press "Search"
    Then I should see the following customer:
      | Name            | Company |
      | Adam Hawkins    | Radium |

  Scenario: The condition is blank
    Given I go to the home page
    And "Adam Hawkins" has bought products
    And there is no record of "Shaun Densberger"'s transactions
    When I select "Bought Products" from "Attribute"
    And I select "Is blank" from "Operator"
    And I press "Search"
    Then I should see the following customer:
      | Name         | Company |
      | Shaun Densberger | Radium  |

  Scenario: The condition is not blank
    Given I go to the home page
    And there is no record of "Adam Hawkins"'s transactions
    And "Shaun Densberger" has bought products
    When I select "Bought Products" from "Attribute"
    And I select "Is not blank" from "Operator"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Shaun Densberger | Radium  |
