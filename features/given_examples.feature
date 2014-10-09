Feature: Given example

  As a user with example configuration
  I want to check whether the theoretical system is in dead lock
  so that I can correct the model

  Scenario: First example
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Waits       |
      | Two     | A        | Waits       |
      | Two     | B        | Holds       |
    When I run the app
    Then the output should be BAD

  Scenario: Waiting on same resource
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Waits       |
      | One     | B        | Holds       |
      | Two     | A        | Waits       |
    When I run the app
    Then the output should be GOOD

  Scenario: Waiting on multiple resource
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Waits       |
      | One     | B        | Waits       |
      | Two     | A        | Holds       |
      | Two     | B        | Waits       |
    When I run the app
    Then the output should be GOOD
