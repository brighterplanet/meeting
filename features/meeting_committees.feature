Feature: Meeting Committee Calculations
  The meeting model should generate correct committee calculations

  Background:
    Given a Meeting

  Scenario: Duration committee from default
    When the "duration" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "28800.0"

  Scenario: Area committee from default
    When the "area" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "970.65096"

  Scenario: State committee from zip code
    Given a characteristic "zip_code.name" of "94122"
    When the "state" committee reports
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "postal_abbreviation" of "CA"

  Scenario: Census division committee from state
    Given a characteristic "state.postal_abbreviation" of "CA"
    When the "census_division" committee reports
    Then the committee should have used quorum "from state"
    And the conclusion of the committee should have "number" of "9"

  Scenario: eGRID subregion committee from default
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "name" of "fallback"

  Scenario: eGRID subregion committee from zip code
    Given a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee reports
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "abbreviation" of "CAMX"

  Scenario: District heat intensity committee from default
    When the "district_heat_intensity" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.00542"

  Scenario: District heat intensity committee from census division
    Given a characteristic "census_division.number" of "9"
    When the "district_heat_intensity" committee reports
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "0.0"

  Scenario: Electricity intensity committee from defaults
    When the "egrid_subregion" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should be "0.09631"

  Scenario: Electricity intensity committee from state
    Given a characteristic "state.postal_abbreviation" of "CA"
    When the "census_division" committee reports
    And the "egrid_subregion" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from eGRID subregion and census division"
    And the conclusion of the committee should be "0.05305"

  Scenario: Electricity intensity committee from zip code
    Given a characteristic "zip_code.name" of "94122"
    When the "state" committee reports
    And the "census_division" committee reports
    And the "egrid_subregion" committee reports
    And the "electricity_intensity" committee reports
    Then the committee should have used quorum "from eGRID subregion and census division"
    And the conclusion of the committee should be "0.05263"

  Scenario: Fuel oil intensity committee from default
    When the "fuel_oil_intensity" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.00377"

  Scenario: Fuel oil intensity committee from census division
    Given a characteristic "census_division.number" of "9"
    When the "fuel_oil_intensity" committee reports
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "0.0"

  Scenario: Natural gas intensity committee from default
    When the "natural_gas_intensity" committee reports
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.01327"

  Scenario: Natural gas intensity committee from census division
    Given a characteristic "census_division.number" of "9"
    When the "natural_gas_intensity" committee reports
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "0.002"

  Scenario: Emission factor committee from nothing
    When the "egrid_subregion" committee reports
    And the "natural_gas_intensity" committee reports
    And the "fuel_oil_intensity" committee reports
    And the "electricity_intensity" committee reports
    And the "district_heat_intensity" committee reports
    And the "emission_factor" committee reports
    Then the committee should have used quorum "from fuel intensities and eGRID"
    And the conclusion of the committee should be "0.06848"

  Scenario: Emission factor committee from state
    Given a characteristic "state.postal_abbreviation" of "CA"
    When the "census_division" committee reports
    And the "egrid_subregion" committee reports
    And the "natural_gas_intensity" committee reports
    And the "fuel_oil_intensity" committee reports
    And the "electricity_intensity" committee reports
    And the "district_heat_intensity" committee reports
    And the "emission_factor" committee reports
    Then the committee should have used quorum "from fuel intensities and eGRID"
    And the conclusion of the committee should be "0.02180"

  Scenario: Emission factor committee from zip code
    Given a characteristic "zip_code.name" of "94122"
    When the "state" committee reports
    And the "census_division" committee reports
    And the "egrid_subregion" committee reports
    And the "natural_gas_intensity" committee reports
    And the "fuel_oil_intensity" committee reports
    And the "electricity_intensity" committee reports
    And the "district_heat_intensity" committee reports
    And the "emission_factor" committee reports
    Then the committee should have used quorum "from fuel intensities and eGRID"
    And the conclusion of the committee should be "0.01965"
