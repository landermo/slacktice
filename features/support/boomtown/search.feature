Feature: search

  Scenario: keyword search
    Given I'm on the home page
    When I search for "King street"
    Then "King street" appears in the filter list
    And there are at least 20 results
    And each result is in King Street

  Scenario: Save Search
    Given I'm on the home page
    When I search for "Charleston"
    And I click "Save This Search"
    And I complete registration
    And I click "Save Search"
    And I name a search
    Then I see my saved search
    And I have a user account

