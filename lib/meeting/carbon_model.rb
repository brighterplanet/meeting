# Copyright © 2010 Brighter Planet.
# See LICENSE for details.
# Contact Brighter Planet for dual-license arrangements.

## Meeting carbon model
# This model is used by [Brighter Planet](http://brighterplanet.com)'s carbon emission [web service](http://carbon.brighterplanet.com) to estimate the **greenhouse gas emissions of a meeting** (e.g. a conference).
#
##### Timeframe and date
# The model estimates the emissions that occur during a particular `timeframe`. To do this it needs to know the meeting's `date`. For example, if the `timeframe` is January 2010, a meeting that occurred on January 11 2010 will have emissions but a meeting that occurred on Febraury 1 2010 will not.
#
##### Calculations
# The final estimate is the result of the **calculations** detailed below. These calculations are performed in reverse order, starting with the last calculation listed and finishing with the `emission` calculation. Each calculation is named according to the value it returns.
#
##### Methods
# To accomodate varying client input, each calculation may have one or more **methods**. These are listed under each calculation in order from most to least preferred. Each method is named according to the values it requires. If any of these values is not available the method will be ignored. If all the methods for a calculation are ignored, the calculation will not return a value. "Default" methods do not require any values, and so a calculation with a default method will always return a value.
#
##### Standard compliance
# Each method lists any established calculation standards with which it **complies**. When compliance with a standard is requested, all methods that do not comply with that standard are ignored. This means that any values a particular method requires will have been calculated using a compliant method, because those are the only methods available. If any value did not have a compliant method in its calculation then it would be undefined, and the current method would have been ignored.
#
##### Collaboration
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](http://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
require 'conversions'

module BrighterPlanet
  module Meeting
    module CarbonModel
      def self.included(base)
        base.decide :emission, :with => :characteristics do
          ### Emission calculation
          # Returns the `emission` estimate (*kg CO<sub>2</sub>e*).
          # This is the total emission produced by the meeting venue.
          committee :emission do
            #### Emission from duration, area, and emission factor
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Multiplies `area` (*square m*) by `duration` (*hours*) and the `emission factor` (*kg CO<sub>2</sub>e / square m hour*) to give *kg CO<sub>2</sub>e*.
            quorum 'from duration, area, and emission factor', :needs => [:duration, :area, :emission_factor] do |characteristics|
              characteristics[:duration] * characteristics[:area] * characteristics[:emission_factor]
            end
            
            #### Default emission
            # **Complies:**
            #
            # Displays an error if the previous method fails.
            quorum 'default' do
              raise "The emission committee's default quorum should never be called"
            end
          end
          
          ### Emission factor calculation
          # Returns the `emission factor` (*lbs CO<sub>2</sub>e / square m hour).
          committee :emission_factor do
            #### Emission factor from fuel intensities and eGRID subregion
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # - Looks up the [natural gas](http://data.brighterplanet.com/fuels) emission factor (*kg CO<sub>2</sub>e / cubic m*)
            # - Looks up the [fuel oil](http://data.brighterplanet.com/fuels) emission factor (*kg CO<sub>2</sub>e / l*)
            # - Looks up the [eGRID subregion](http://data.brighterplanet.com/egrid_subregions) electricity emission factor
            # - Divides the natural gas emission factor (*kg CO<sub>2</sub>e / cubic m*) by the natural gas energy content (38,339,000 *J / cubic m*) to give an energy-based natural gas emission factor (*kg CO<sub>2</sub>e / J*)
            # - Divides the fuel oil emission factor (*kg CO<sub>2</sub>e / l*) by the fuel oil energy content (38,655,000 *J / l*) to give an energy-based fuel oil emission factor (*kg CO<sub>2</sub>e / J*)
            # - Divides the energy-based natural gas emission factor by 0.817 and the energy-based fuel oil emission factor by 0.846, adds these together and divides by 2, and divides by 0.95. This gives a district heat emission factor (*kg CO<sub>2</sub>e / J*) based on the assumption that district heat is produced by 50% natural gas and 50% fuel oil, natural gas boilers are 81.7% efficient, fuel oil boilers are 84.6% efficient, and transmission losses are 5%.
            # - Multiplies `natural gas intensity` by the natural gas emission factor, `fuel oil intensity` by the fuel oil emission factor, `electricity intensity` by the electricity emission factor, and `district heat intensity` by the district heat emission factor
            # - Adds these together
            quorum 'from eGRID subregion and fuel intensities', :needs => [:egrid_subregion, :natural_gas_intensity, :fuel_oil_intensity, :electricity_intensity, :district_heat_intensity] do |characteristics|
              natural_gas = FuelType.find_by_name "Commercial Natural Gas"
              fuel_oil = FuelType.find_by_name "Distillate Fuel Oil 2"
              natural_gas_energy_ef = natural_gas.emission_factor / 38_339_000
              fuel_oil_energy_ef = fuel_oil.emission_factor / 38_655_000
              district_heat_emission_factor = (((natural_gas_energy_ef / 0.817) / 2) + ((fuel_oil_energy_ef / 0.846) / 2)) / 0.95
              
              (characteristics[:natural_gas_intensity] * natural_gas.emission_factor) +
                (characteristics[:fuel_oil_intensity] * fuel_oil.emission_factor) +
                (characteristics[:electricity_intensity] * characteristics[:egrid_subregion].electricity_emission_factor) +
                (characteristics[:district_heat_intensity] * district_heat_emission_factor)
            end
          end
          
          ### Natural gas intensity calculation
          # Returns the meeting venue's `natural gas intensity` (*cubic m / square m hour*).
          committee :natural_gas_intensity do # returns cubic metres per square metre hour
            #### From census division
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [census division](http://data.brighterplanet.com/census_divisions) meeting building `natural gas intensity` (*cubic m / square m hour*).
            quorum 'from census division', :needs => :census_division do |characteristics|
              characteristics[:census_division].meeting_building_natural_gas_intensity
            end
            
            #### Default natural gas intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses the U.S. average `natural gas intensity` (*cubic m / square m hour*).
            quorum 'default' do
              CensusDivision.fallback.meeting_building_natural_gas_intensity
            end
          end
          
          ### Fuel oil intensity calculation
          # Returns the meeting venue's `fuel oil intensity` (*l / square m hour*).
          committee :fuel_oil_intensity do
            #### Fuel oil intensity from census division
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [census division](http://data.brighterplanet.com/census_divisions) meeting building `fuel oil intensity` (*l / square m hour*).
            quorum 'from census division', :needs => :census_division do |characteristics|
              characteristics[:census_division].meeting_building_fuel_oil_intensity
            end
            
            #### Default fuel oil intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses the U.S. average `fuel oil intensity` (*l / square m hour*).
            quorum 'default' do
              CensusDivision.fallback.meeting_building_fuel_oil_intensity
            end
          end
          
          ### Electricity intensity calculation
          # Returns the meeting venue's `electricity intensity` (*kWh / square m hour*).
          committee :electricity_intensity do
            #### Electricity intensity from census division and eGRID region
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # - Looks up the [census division](http://data.brighterplanet.com/census_divisions) meeting building `electricity intensity` (*kWh / square m hour*)
            # - Looks up the [eGRID region](http://data.brighterplanet.com/egrid_regions) loss factor
            # - Divides the `electricity intensity` by 1 - the loss factor to account for electricity transmission and distribution losses
            quorum 'from eGRID region and census division', :needs => [:egrid_region, :census_division] do |characteristics|
              characteristics[:census_division].meeting_building_electricity_intensity / (1 - characteristics[:egrid_region].loss_factor)
            end
            
            #### Electricity intensity from eGRID region
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # - Uses the U.S. average meeting building `electricity intensity` (*kWh / square m hour*)
            # - Looks up the [eGRID region](http://data.brighterplanet.com/egrid_regions) loss factor
            # - Divides the `electricity intensity` by (1 - the loss factor) to account for electricity transmission and distribution losses
            quorum 'from eGRID region', :needs => :egrid_region do |characteristics|
              CensusDivision.fallback.meeting_building_electricity_intensity / (1 - characteristics[:egrid_region].loss_factor)
            end
          end
          
          ### District heat intensity calculation
          # Returns the meeting venue's `district heat intensity` (*J / square m hour*)
          committee :district_heat_intensity do
            #### District heat intensity from census division
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [census division](http://data.brighterplanet.com/census_divisions) meeting building `district heat intensity`.
            quorum 'from census division', :needs => :census_division do |characteristics|
              characteristics[:census_division].meeting_building_district_heat_intensity
            end
            
            #### Default district heat intensity
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses the U.S. average.
            quorum 'default' do
              CensusDivision.fallback.meeting_building_district_heat_intensity
            end
          end
          
          ### eGRID region calculation
          # Returns the meeting venue's [eGRID region](http://data.brighterplanet.com/egrid_regions).
          committee :egrid_region do
            #### eGRID region from eGRID subregion
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [eGRID subregion](http://data.brighterplanet.com/egrid_subregions) `eGRID region`.
            quorum 'from eGRID subregion', :needs => :egrid_subregion do |characteristics|
              characteristics[:egrid_subregion].egrid_region
            end
          end
          
          ### eGRID subregion calculation
          # Returns the meeting venue's [eGRID subregion](http://data.brighterplanet.com/egrid_subregions).
          committee :egrid_subregion do
            #### eGRID subregion from zip code
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [zip code](http://data.brighterplanet.com/zip_codes) `eGRID subregion`.
            quorum 'from zip code', :needs => :zip_code do |characteristics|
              characteristics[:zip_code].egrid_subregion
            end
            
            #### Default eGRID subregion
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses an artificial eGRID subregion that represents the U.S. average.
            quorum 'default' do
              EgridSubregion.find_by_abbreviation 'US'
            end
          end
          
          ### Census division calculation
          # Returns the meeting venue's [census division](http://data.brighterplanet.com/census_divisions).
          committee :census_division do
            #### Census division from state
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [state](http://data.brighterplanet.com/states) `census division`.
            quorum 'from state', :needs => :state do |characteristics|
              characteristics[:state].census_division
            end
          end
          
          ### State calculation
          # Returns the meeting venue's [state](http://data.brighterplanet.com/states).
          committee :state do
            #### State from zip code
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Looks up the [zip code](http://data.brighterplanet.com/zip_codes) `state`.
            quorum 'from zip code', :needs => :zip_code do |characteristics|
              characteristics[:zip_code].state
            end
          end
          
          ### Zip code calculation
          # Returns the meeting venue's [zip code](http://data.brighterplanet.com/zip_codes).
            #### Zip code from client input
            # **Complies:** All
            #
            # Uses the client-input [zip code](http://data.brighterplanet.com/zip_codes).
          
          ### Area calculation
          # Returns the meeting venue's `area` (*square m*).
          committee :area do
            #### Area from client input
            # **Complies:** All
            #
            # Uses the client-input `area` (*square m*).
            
            #### Default area
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses a default `area` of 1,184.5 *square m*.
            # This is the median size of buildings in the [EIA Commercial Building Energy Consumption Survey](http://www.eia.doe.gov/emeu/cbecs/).
            quorum 'default' do
              base.fallback.area
            end
          end
          
          ### Duration calculation
          # Returns the meeting's `duration` (hours).
          committee :duration do
            #### Duration from client input
            # **Complies:** All
            #
            # Uses the client-input `duration` (*hours*).
            
            #### Default duration
            # **Complies:** GHG Protocol, ISO 14064-1, Climate Registry Protocol
            #
            # Uses a default `duration` of 8 *hours*.
            quorum 'default' do
              8
            end
          end
        end
      end
    end
  end
end
