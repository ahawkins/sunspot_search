@javascript
Feature: Float Searches

  Background:
    Given there are these customers: 
      | Name             | Company  | Rating |
      | Adam Hawkins     | Radium   | 88.8   |
      | Shaun Densberger | Radium   | 45.7   |

  Scenario Outline: The condition is more than
    Given I go to the home page
    When I select "Rating" from "Attribute"
    And I select "More than" from "Operator"
    And I fill in "Value" with "<value>"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Adam Hawkins     | Radium  |

    Examples: 
      | value |
      | 85  |
      | 85,00 |
      | 85.0 |

  Scenario Outline: The condition is less than
    Given I go to the home page
    When I select "Rating" from "Attribute"
    And I select "Less than" from "Operator"
    And I fill in "Value" with "<value>"
    And I press "Search"
    Then I should see the following customer:
      | Name             | Company |
      | Shaun Densberger | Radium  |

    Examples: 
      | value |
      | 85  |
      | 85,00 |
      | 85.0 |

  Scenario Outline: The conditions is a range
    Given I go to the home page
    When I select "Rating" from "Attribute"
    And I select "Between" from "Operator"
    And I fill in "Value" with "<value>"
    And I select "Name" from "Sort by"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |

    Examples:
      | value |
      | 45-90 |
      | 45,00-90.00 |
      | 45.0-90,00 |

  @wip
  Scenario Outline: The condition is equal to
    Given I go to the home page
    When I select "Rating" from "Attribute"
    And I select "Is" from "Operator"
    And I fill in "Value" with "<value>"
    And I press "Search"
    Then I should see the following customer:
      | Name            | Company |
      | Shaun Densbeger | Radium  |

    Examples: 
      | value |
      | 45.7  |
      | 45,70 |
      | 45.7 |

  Scenario: The condition is blank
    Given I go to the home page
    When I select "Rating" from "Attribute"
    And I select "Is blank" from "Operator"
    And I press "Search"
    Then I should not see any customers

  Scenario: The revenue is not blank
    Given I go to the home page
    When I select "Rating" from "Attribute"
    And I select "Is not blank" from "Operator"
    And I press "Search"
    Then I should see the following customers:
      | Name             | Company |
      | Adam Hawkins     | Radium  |
      | Shaun Densberger | Radium  |
