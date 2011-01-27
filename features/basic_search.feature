Feature: Basic Search
  SolrSearch provides the functionality to create basic searches.
  This include things like: 

     * Keyword search (google style textbox)
     * Per Page configuration
     * Order Fields
     * Choosing Fields for keyword searches

  Scenario: The users keywords matches a customer
    Given there are these customers: 
     | Name             | Company  |
     | Adam Hawkins     | Radium   |
     | Shaun Densberger | LLNL     |
   When I go to the home page
   And I fill in "Search" with "Adam"
   And I press "Search"
   Then I should see the following customer:
    | Name             | Company |
    | Adam Hawkins     | Radium  |

  Scenario: The user chooses a sort order
    Given there are these customers: 
     | Name             | Company            |
     | Adam Hawkins     | Ruby Programmers   |
     | Shaun Densberger | Python Programmers |
   When I go to the home page
   And I fill in "Search" with "Programmers"
   And I select "Name" from "Sort by"
   And I choose "Reverse Order"
   And I press "Search"
   Then I should see the following customer:
     | Name             | Company            |
     | Shaun Densberger | Python Programmers |
     | Adam Hawkins     | Ruby Programmers   |

  Scenario: The form has some pagination configuration
    When I go to the home page
    Then I should see the following options for "Per page": 
      | option |
      | 50     | 
      | 100    |
      | 150    |
      | 200    |
