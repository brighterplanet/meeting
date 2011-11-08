Feature: Meeting Emissions Calculations
  The meeting model should generate correct emission calculations

  Background:
    Given a Meeting

  Scenario: Calculations starting from nothing
    Given a meeting has nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "756.67"

  Scenario: Calculations starting from duration
    Given it has "duration" of "3600.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "94.58"

  Scenario: Calculations starting from area
    Given it has "area" of "500"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "389.77"

  Scenario: Calculations starting from state
    Given it has "state.postal_abbreviation" of "CA"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "293.15"

  Scenario: Calculations starting from zip code
    Given it has "zip_code.name" of "94122"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "158.57"

  Scenario: Calculations starting from duration, area, and zip code
    Given it has "duration" of "3600.0"
    And it has "area" of "500"
    And it has "zip_code.name" of "94122"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "10.21"
