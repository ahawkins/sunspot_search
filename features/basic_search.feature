Feature: Basic Search
  SolrSearch provides the functionality to create basic searches.
  This include things like: 

     * Keyword search (google style textbox)
     * Per Page configuration
     * Order Fields
     * Choosing Fields for keyword searches

  Scenario: The users keywords matches a customer
    Given there is this customer: 
     | Name         | Company  |
     | Adam Hawkins | Radium   |
   When I go to the home page
   And I fill in "Search" with "Adam"
   And I press "Search"
   Then I should see the following customer:
    | Name         | Company |
    | Adam Hawkins | Radium | 
