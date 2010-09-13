Feature: Meeting Committee Calculations
  The meeting model should generate correct committee calculations

  Scenario: Emission committee from fuel use and emission factor
    Given an meeting emitter
    When the "emission" committee is calculated
    Then the committee should have used quorum "from default"
    And the conclusion of the committee should be "100"
