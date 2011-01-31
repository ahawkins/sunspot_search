@javascript
Feature: Time attributes

  Background:
    Given there are these customers: 
      | Name             | Company  | LastContacted  |
      | Adam Hawkins     | Radium   | 2010/12/15 5pm |
      | Shaun Densberger | Radium   | 2010/09/19 5pm |

  Scenario: The condition is after
    Given I go to the home page
    When I select "Last Contacted" from "Attribute"
    And I select "After" from "Operator"
    And I fill in "Value" with "2010/12/02"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Adam Hawkins     | Radium  |

  Scenario: The condition is before
    Given I go to the home page
    When I select "Last Contacted" from "Attribute"
    And I select "Before" from "Operator"
    And I fill in "Value" with "2010/12/02"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Shaun Densberger | Radium  |

  Scenario: The conditions is a range
    Given I go to the home page
    When I select "Last Contacted" from "Attribute"
    And I select "Between" from "Operator"
    And I fill in "Value" with "2010/06/01-2011/04/01"
    And I select "Name" from "Sort by"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |

  Scenario: The condition is equal to
    Given I go to the home page
    When I select "Last Contacted" from "Attribute"
    And I select "Is" from "Operator"
    And I fill in "Value" with "2010/12/15"
    And I press "Search"
    Then I should see the following customer:
      | Name         | Company |
      | Adam Hawkins | Radium  |

  Scenario: The condition is blank
    Given I go to the home page
    When I select "Last Contacted" from "Attribute"
    And I select "Is blank" from "Operator"
    And I press "Search"
    Then I should not see any customers

  Scenario: The revenue is not blank
    Given I go to the home page
    When I select "Last Contacted" from "Attribute"
    And I select "Is not blank" from "Operator"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |
