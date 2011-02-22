Feature: Meeting Emissions Calculations
  The meeting model should generate correct emission calculations

  Scenario: Calculations starting from nothing
    Given a meeting has nothing
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "756.67"

  Scenario: Calculations starting from duration
    Given a meeting has "duration" of "1"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "94.58"

  Scenario: Calculations starting from area
    Given a meeting has "area" of "500"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "389.77"

  Scenario: Calculations starting from state
    Given a meeting has "state.postal_abbreviation" of "CA"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "293.15"

  Scenario: Calculations starting from zip code
    Given a meeting has "zip_code.name" of "94122"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "158.57"

  Scenario: Calculations starting from duration, area, and zip code
    Given a meeting has "duration" of "1"
    And it has "area" of "500"
    And it has "zip_code.name" of "94122"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "10.21"
