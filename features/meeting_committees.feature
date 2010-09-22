Feature: Meeting Committee Calculations
  The meeting model should generate correct committee calculations

  Scenario: Duration committee from default
    Given a meeting emitter
    When the "duration" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "8"

  Scenario: Area committee from default
    Given a meeting emitter
    When the "area" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "1184.51376"

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

  Scenario: eGRID subregion committee from zip code
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee is calculated
    Then the committee should have used quorum "from zip code"
    And the conclusion of the committee should have "abbreviation" of "CAMX"

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
    And the conclusion of the committee should be "3458.7"

  Scenario: District heat intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "district_heat_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "1000"

  Scenario: Electricity intensity committee from default
    Given a meeting emitter
    When the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.072444"

  Scenario: Electricity intensity committee from eGRID region
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "from eGRID region"
    And the conclusion of the committee should be "0.080493"

  Scenario: Electricity intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "3"

  Scenario: Electricity intensity committee from eGRID region and census division
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "state" committee is calculated
    And the "census_division" committee is calculated
    And the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "electricity_intensity" committee is calculated
    Then the committee should have used quorum "from eGRID region and census division"
    And the conclusion of the committee should be "3.33333"

  Scenario: Fuel oil intensity committee from default
    Given a meeting emitter
    When the "fuel_oil_intensity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.0037381"

  Scenario: Fuel oil intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "fuel_oil_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "2"

  Scenario: Natural gas intensity committee from default
    Given a meeting emitter
    When the "natural_gas_intensity" committee is calculated
    Then the committee should have used quorum "default"
    And the conclusion of the committee should be "0.011973"

  Scenario: Natural gas intensity committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "natural_gas_intensity" committee is calculated
    Then the committee should have used quorum "from census division"
    And the conclusion of the committee should be "1"

  Scenario: Emission factor committee from nothing
    Given a meeting emitter
    When the "natural_gas_intensity" committee is calculated
    And the "fuel_oil_intensity" committee is calculated
    And the "electricity_intensity" committee is calculated
    And the "district_heat_intensity" committee is calculated
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from fuel intensities"
    And the conclusion of the committee should be "0.15470"

  Scenario: Emission factor committee from census division
    Given a meeting emitter
    And a characteristic "census_division.number" of "9"
    When the "natural_gas_intensity" committee is calculated
    And the "fuel_oil_intensity" committee is calculated
    And the "electricity_intensity" committee is calculated
    And the "district_heat_intensity" committee is calculated
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from fuel intensities"
    And the conclusion of the committee should be "8.50002"

  Scenario: Emission factor committee from eGRID subregion
    Given a meeting emitter
    And a characteristic "zip_code.name" of "94122"
    When the "egrid_subregion" committee is calculated
    And the "egrid_region" committee is calculated
    And the "natural_gas_intensity" committee is calculated
    And the "fuel_oil_intensity" committee is calculated
    And the "electricity_intensity" committee is calculated
    And the "district_heat_intensity" committee is calculated
    And the "emission_factor" committee is calculated
    Then the committee should have used quorum "from eGRID subregion and fuel intensities"
    And the conclusion of the committee should be "0.09030"

  Scenario: Emission factor committee from eGRID subregion and census division
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
    Then the committee should have used quorum "from eGRID subregion and fuel intensities"
    And the conclusion of the committee should be "5.83336"
