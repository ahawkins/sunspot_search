@javascript
Feature: Conditional Search

  @wip
  Scenario: The search conditions are inclusive
   Given there are these customers: 
     | Name             | Company  | Revenue | Business |
     | Adam Hawkins     | Radium   | 10000   | Sales    |
     | Shaun Densberger | Radium   | 500     | Support  |
   When I go to the home page
   Then show me the page
   And I fill in "Search" with "Adam"
   Then I choose "Revenue" for "Field" within "#fields"
   And I choose "At least" for "Operator" within "#fields"
   And I fill in "Value" with "$1,000"
   And I press "Search"
   Then I should see the following customer:
    | Name             | Company |
    | Adam Hawkins     | Radium  |
