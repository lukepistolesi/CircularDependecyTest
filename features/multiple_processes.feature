Feature: Multiple processes

  As a user with a multi-process system
  I want to analyze the system
  so that I am sure it is not in dead lock

  Scenario: All resources are held
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | Two     | B        | Holds       |
    When I run the app
    Then the output should be GOOD

  Scenario: Waiting for a resource
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | Two     | B        | Waits       |
    When I run the app
    Then the output should be GOOD

  Scenario: Waiting for multiple resources
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Waits       |
      | One     | B        | Holds       |
      | Two     | A        | Waits       |
    When I run the app
    Then the output should be GOOD

  Scenario: Deadlock
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Waits       |
      | Two     | A        | Waits       |
      | Two     | B        | Holds       |
    When I run the app
    Then the output should be BAD

  Scenario: Multiple Deadlock
    Given the following processes and resources
      | Process | Resource | Interaction |
      | One     | A        | Holds       |
      | One     | B        | Waits       |
      | Two     | A        | Waits       |
      | Two     | B        | Holds       |
      | Three   | C        | Holds       |
      | Three   | D        | Waits       |
      | Four    | C        | Waits       |
      | Four    | D        | Holds       |
    When I run the app
    Then the output should be BAD
