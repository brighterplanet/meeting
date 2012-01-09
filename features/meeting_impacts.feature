Feature: Meeting Emissions Calculations
  The meeting model should generate correct emission calculations

  Background:
    Given a Meeting

  Scenario: Calculations starting from nothing
    Given a meeting has nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "531.8"

  Scenario Outline: Calculations starting from date
    Given it has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "<carbon>"
    Examples:
      | date       | timeframe             | carbon |
      | 2011-01-15 | 2011-01-01/2012-01-01 | 531.8  |
      | 2012-01-15 | 2011-01-01/2012-01-01 |   0.0  |

  Scenario: Calculations starting from duration
    Given it has "duration" of "3600.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "66.5"

  Scenario: Calculations starting from area
    Given it has "area" of "500"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "273.9"

  Scenario: Calculations starting from state
    Given it has "state.postal_abbreviation" of "CA"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "169.3"

  Scenario: Calculations starting from zip code
    Given it has "zip_code.name" of "94122"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "152.6"

  Scenario: Calculations starting from duration, area, and zip code
    Given it has "duration" of "3600.0"
    And it has "area" of "500"
    And it has "zip_code.name" of "94122"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.1" of "9.8"
