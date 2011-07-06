Feature: Meeting Committee Calculations
  The meeting model should generate correct committee calculations

  Scenario: Duration committee from default
    Given a meeting emitter
    When the "duration" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "28800.0"

  Scenario: Area committee from default
    Given a meeting emitter
    When the "area" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "970.65096"

  Scenario: State committee from zip code
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "state" committee is calculated
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "postal_abbreviation" of "CA"

  Scenario: Census division committee from state
    Given a meeting emitter
    And a characteristic "state.postal_abbreviation" of "CA"
    When the "census_division" committee is calculated
    Then the committee should have used quorum "from state"
    And the conclusion of the committee should have "number" of "9"

  Scenario: eGRID subregion committee from default
    Given a meeting emitter
    When the "egrid_subregion" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should have "abbreviation" of "US"

  Scenario: eGRID subregion committee from zip code
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee is calculated
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "abbreviation" of "CAMX"

  Scenario: eGRID region committee from nothing
    Given a meeting emitter
    When the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should have "name" of "US"

  Scenario: eGRID region committee from eGRID subregion
    Given a meeting emitter
    And a characteristic "egrid_subregion.abbreviation" of "CAMX"
    When the "egrid_region" committee is calculated
    Then the committee should have used quorum "from eGRID subregion"
    And the conclusion of the committee should have "name" of "W"

  Scenario: District heat intensity committee from default
    Given a meeting emitter
    When the "district_heat_intensity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.00542"

  Scenario: District heat intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "district_heat_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "0.0"

  Scenario: Electricity intensity committee from default
    Given a meeting emitter
    When the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "from eGRID region"
    And the conclusion of the committee should be "0.09656"

  Scenario: Electricity intensity committee from state
    Given a meeting emitter
    And a characteristic "state.postal_abbreviation" of "CA"
    When the "census_division" committee is calculated
    And the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "from eGRID region and census division"
    And the conclusion of the committee should be "0.05319"

  Scenario: Electricity intensity committee from eGRID region and census division
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "state" committee is calculated
    And the "census_division" committee is calculated
    And the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "from eGRID region and census division"
    And the conclusion of the committee should be "0.05263"

  Scenario: Fuel oil intensity committee from default
    Given a meeting emitter
    When the "fuel_oil_intensity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.00377"

  Scenario: Fuel oil intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "fuel_oil_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "0.0"

  Scenario: Natural gas intensity committee from default
    Given a meeting emitter
    When the "natural_gas_intensity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.01327"

  Scenario: Natural gas intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "natural_gas_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "0.002"

  Scenario: Emission factor committee from nothing
    Given a meeting emitter
    When the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "natural_gas_intensity" committee is calculated
    And the "fuel_oil_intensity" committee is calculated
    And the "electricity_intensity" committee is calculated
    And the "district_heat_intensity" committee is calculated
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from fuel intensities and eGRID"
    And the conclusion of the committee should be "0.09744"

  Scenario: Emission factor committee from state
    Given a meeting emitter
    And a characteristic "state.postal_abbreviation" of "CA"
    When the "census_division" committee is calculated
    And the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "natural_gas_intensity" committee is calculated
    And the "fuel_oil_intensity" committee is calculated
    And the "electricity_intensity" committee is calculated
    And the "district_heat_intensity" committee is calculated
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from fuel intensities and eGRID"
    And the conclusion of the committee should be "0.03775"

  Scenario: Emission factor committee from zip code
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "state" committee is calculated
    And the "census_division" committee is calculated
    And the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "natural_gas_intensity" committee is calculated
    And the "fuel_oil_intensity" committee is calculated
    And the "electricity_intensity" committee is calculated
    And the "district_heat_intensity" committee is calculated
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from fuel intensities and eGRID"
    And the conclusion of the committee should be "0.02042"
