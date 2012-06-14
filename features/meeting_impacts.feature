Feature: Meeting Emissions Calculations
  The meeting model should generate correct emission calculations

  Background:
    Given a Meeting

  Scenario: Calculations starting from nothing
    Given a meeting has nothing
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "514.11"

  Scenario Outline: Calculations starting from date
    Given it has "date" of "<date>"
    And it has "timeframe" of "<timeframe>"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "<carbon>"
    Examples:
      | date       | timeframe             | carbon |
      | 2011-01-15 | 2011-01-01/2012-01-01 | 514.11 |
      | 2012-01-15 | 2011-01-01/2012-01-01 |   0.0  |

  Scenario: Calculations starting from duration
    Given it has "duration" of "3600.0"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "64.26"

  Scenario: Calculations starting from area
    Given it has "area" of "500"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "264.83"

  Scenario: Calculations starting from state
    Given it has "state.postal_abbreviation" of "CA"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "152.12"

  Scenario: Calculations starting from zip code
    Given it has "zip_code.name" of "94122"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "156.11"

  Scenario: Calculations starting from duration, area, and zip code
    Given it has "duration" of "3600.0"
    And it has "area" of "500"
    And it has "zip_code.name" of "94122"
    When impacts are calculated
    Then the amount of "carbon" should be within "0.01" of "10.05"
