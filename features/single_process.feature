Feature: Single process

  As a user with a single-process system
  I want to analyze the system
  so that I am sure it is not in dead lock

  Scenario: All resources are held
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Holds       |
    When I run the app
    Then the output should be GOOD
@wip
  Scenario: Waiting for a resource
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Waits       |
    When I run the app
    Then the output should be GOOD
@wip
  Scenario: Waiting for multiple resources
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Waits       |
      | One     | B        | Holds       |
      | One     | C        | Waits       |
    When I run the app
    Then the output should be GOOD
@wip
  Scenario: Self deadlock
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Waits       |
    When I run the app
    Then the output should be BAD
