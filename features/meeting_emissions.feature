Feature: Meeting Emissions Calculations
  The meeting model should generate correct emission calculations

  Scenario: Calculations starting from nothing
    Given a meeting has nothing
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "1465.9"

  Scenario: Calculations starting from duration
    Given a meeting has "duration" of "1"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "183.2"

  Scenario: Calculations starting from area
    Given a meeting has "area" of "1000"
    When emissions are calculated
    Then the emission value should be within "1" kgs of "1237.6"

  Scenario: Calculations starting from zip code
    Given a meeting has "zip_code.name" of "94122"
    When emissions are calculated
    Then the emission value should be within "1" kgs of "80547"

  Scenario: Calculations starting from duration, area, and zip code
    Given a meeting has "duration" of "1"
    And it has "area" of "1000"
    And it has "zip_code.name" of "94122"
    When emissions are calculated
    Then the emission value should be within "0.1" kgs of "8500.0"
