Feature: Given example

  As a user with example configuration
  I want to check whether the theoretical system is in dead lock
  so that I can correct the model

  @wip
  Scenario: First example
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Waits       |
      | Two     | A        | Waits       |
      | Two     | B        | Holds       |
    When I run the app
    Then the output should be BAD
