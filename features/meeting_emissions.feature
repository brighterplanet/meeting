Feature: Meeting Emissions Calculations
  The meeting model should generate correct emission calculations

  Scenario: Calculations starting from nothing
    Given an meeting has nothing
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "100"
