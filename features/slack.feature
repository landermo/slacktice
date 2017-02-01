Feature: Slack

  Scenario: posting a message using the API
    Given I am Laura
#     When I send a message to #test
    When I send a message from the #test page
    Then I should see that message on the test page