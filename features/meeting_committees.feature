Feature: Meeting Committee Calculations
  The meeting model should generate correct committee calculations

  Background:
    Given a Meeting

  Scenario: Date committee
    Given a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "date" committee reports
    Then the committee should have used quorum "from timeframe"
    And the conclusion of the committee should be "2010-01-01"

  Scenario: Duration committee
    When the "duration" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "28800.0"

  Scenario: Area committee
    When the "area" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "970.65096"

  Scenario: State committee
    Given a characteristic "zip_code.name" of "94122"
    When the "state" committee reports
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "postal_abbreviation" of "CA"

  Scenario Outline: Census division committee
    Given a characteristic "state.postal_abbreviation" of "<state>"
    When the "census_division" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should have "name" of "<census_division>"
    Examples:
      | state | census_division  | quorum     |
      |       | fallback         | default    |
      | CA    | Pacific Division | from state |

  Scenario: eGRID subregion committee
    Given a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "abbreviation" of "CAMX"

  Scenario Outline: District heat use committee
    Given a characteristic "state.postal_abbreviation" of "<state>"
    When the "area" committee reports
    And the "duration" committee reports
    And the "census_division" committee reports
    And the "district_heat_use" committee reports
    Then the committee should have used quorum "from census division, area, and duration"
    And the conclusion of the committee should be "<dist_heat>"
    Examples:
      | state | dist_heat |
      |       | 42.12080  |
      | CA    |  0.0      |

  Scenario Outline: Electricity use committee
    Given a characteristic "state.postal_abbreviation" of "<state>"
    When the "area" committee reports
    And the "duration" committee reports
    And the "census_division" committee reports
    And the "electricity_use" committee reports
    Then the committee should have used quorum "from census division, area, and duration"
    And the conclusion of the committee should be "<electricity>"
    Examples:
      | state | electricity |
      |       | 704.81108   |
      | CA    | 388.26038   |

  Scenario Outline: Fuel oil use committee
    Given a characteristic "state.postal_abbreviation" of "<state>"
    When the "area" committee reports
    And the "duration" committee reports
    And the "census_division" committee reports
    And the "fuel_oil_use" committee reports
    Then the committee should have used quorum "from census division, area, and duration"
    And the conclusion of the committee should be "<fuel_oil>"
    Examples:
      | state | fuel_oil |
      |       | 29.28575 |
      | CA    |  0.0     |

  Scenario Outline: Natural gas use committee
    Given a characteristic "state.postal_abbreviation" of "<state>"
    When the "area" committee reports
    And the "duration" committee reports
    And the "census_division" committee reports
    And the "natural_gas_use" committee reports
    Then the committee should have used quorum "from census division, area, and duration"
    And the conclusion of the committee should be "<nat_gas>"
    Examples:
      | state | nat_gas   |
      |       | 103.04290 |
      | CA    |  15.53042 |

  Scenario Outline: Electricity emission factor committee
    Given a characteristic "state.postal_abbreviation" of "<state>"
    And a characteristic "zip_code.name" of "<zip>"
    When the "egrid_subregion" committee reports
    And the "electricity_emission_factor" committee reports
    Then the committee should have used quorum "<quorum>"
    And the conclusion of the committee should be "<ef>"
    Examples:
      | state | zip   | ef      | quorum               |
      |       |       | 0.33468 | default              |
      | CA    |       | 0.31579 | from state           |
      | CA    | 94122 | 0.32609 | from eGRID subregion |

  Scenario: Carbon committee
    Given a characteristic "natural_gas_use" of "10"
    And a characteristic "fuel_oil_use" of "10"
    And a characteristic "electricity_use" of "10"
    And a characteristic "district_heat_use" of "10"
    And a characteristic "electricity_emission_factor" of "0.5"
    And a characteristic "date" of "2010-07-01"
    And a characteristic "timeframe" of "2010-01-01/2011-01-01"
    When the "carbon" committee reports
    Then the committee should have used quorum "from fuel uses, electricity emission factor, date, and timeframe"
    And the conclusion of the committee should be "51.8"
