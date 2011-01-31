@javascript
Feature: Conditional Search

  Scenario: The search has a currency
   Given there are these customers: 
     | Name             | Company  | Revenue | Business |
     | Adam Hawkins     | Radium   | 10000   | Sales    |
     | Shaun Densberger | Radium   | 500     | Support  |
   When I go to the home page
   And I fill in "Search" with "Adam"
   And I select "Revenue" from "Attribute"
   And I select "More than" from "Operator"
   And I fill in "Value" with "$1,000"
   And I press "Search"
   Then I should see the following customer:
    | Name             | Company |
    | Adam Hawkins     | Radium  |
