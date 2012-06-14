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
# Contributions to this carbon model are actively encouraged and warmly welcomed. This library includes a comprehensive test suite to ensure that your changes do not cause regressions. All changes should include test coverage for new functionality. Please see [sniff](https://github.com/brighterplanet/sniff#readme), our emitter testing framework, for more information.
require 'conversions'

module BrighterPlanet
  module Meeting
    module ImpactModel
      def self.included(base)
        base.decide :impact, :with => :characteristics do
          # * * *
          
          #### Carbon (*kg CO<sub>2</sub>e*)
          # *The meeting's total anthropogenic greenhouse gas emissions during `timeframe`.*
          committee :carbon do
            # If `date` falls within `timeframe` multiply each fuel use by the fuel's emission factor and sum to give *kg CO</sub>2</sub>e*. Otherwise carbon is zero.
            quorum 'from fuel uses, electricity emission factor, date, and timeframe', :needs => [:natural_gas_use, :fuel_oil_use, :electricity_use, :district_heat_use, :electricity_emission_factor, :date],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics, timeframe|
                date = characteristics[:date].is_a?(Date) ? characteristics[:date] : Date.parse(characteristics[:date].to_s)
                if timeframe.include? date
                   (characteristics[:natural_gas_use] * Fuel.find('Pipeline Natural Gas').co2_emission_factor) +
                   (characteristics[:fuel_oil_use] * Fuel.find('Distillate Fuel Oil No. 2').co2_emission_factor) +
                   (characteristics[:electricity_use] * characteristics[:electricity_emission_factor]) +
                   (characteristics[:district_heat_use] * Fuel.find('District Heat').co2_emission_factor)
                else
                  0
                end
            end
            
            #### Default emission
            quorum 'default' do
              # Displays an error if the previous method fails.
              raise "The emission committee's default quorum should never be called"
            end
          end
          
          #### Electricity emission factor (*kg CO<sub>2</sub>e / kWh*)
          # *A greenhouse gas emission factor for the meeting's electricity use including transmission and distribution losses.*
          committee :electricity_emission_factor do
            # Divide the `eGRID subregion` electricity emission factor (*kg CO<sub>2</sub>e / kWh*) by 1 minus the `eGRID subregion` eGRID region loss factor to give *kg CO<sub>2</sub>e / kWh*.
            quorum 'from eGRID subregion', :needs => :egrid_subregion,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:egrid_subregion].electricity_emission_factor / (1 - characteristics[:egrid_subregion].egrid_region.loss_factor)
            end
            
            # Divide the `state` electricity emission factor (*kg CO<sub>2</sub>e / kWh*) by 1 minus the state electricity loss factor to give *kg CO<sub>2</sub>e / kWh*.
            quorum 'from state', :needs => :state,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:state].electricity_emission_factor / (1 - characteristics[:state].electricity_loss_factor)
            end
            
            # Otherwise divide the U.S. average electricity emission factor (*kg CO<sub>2</sub>e / kWh*) by the U.S. average electricity loss factor to give *kg CO<sub>2</sub>e / kWh*.
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                EgridSubregion.fallback.electricity_emission_factor / (1 - EgridSubregion.fallback.egrid_region.loss_factor)
            end
          end
          
          #### Natural gas use (*m<sup>3</sup>*)
          # *The meeting's natural gas use.*
          committee :natural_gas_use do
            # Multiply the `census division` meeting building natural gas intensity (*m<sup>3</sup> / m<sup>2</sup> hour*) by `area` (*m<sup>2</sup>*) and `duration` (*seconds*) / 3600 (*seconds / hour*) to give *m<sup>3</sup>*.
            quorum 'from census division, area, and duration', :needs => [:census_division, :area, :duration],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:census_division].meeting_building_natural_gas_intensity *
                  characteristics[:area] *
                  characteristics[:duration] / 3600.0
            end
          end
          
          #### Fuel oil use (*l*)
          # *The meeting's fuel oil use.*
          committee :fuel_oil_use do
            # Multiply the `census division` meeting building fuel oil intensity (*l / m<sup>2</sup> hour*) by `area` (*m<sup>2</sup>*) and `duration` (*seconds*) / 3600 (*seconds / hour*) to give *l*.
            quorum 'from census division, area, and duration', :needs => [:census_division, :area, :duration],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:census_division].meeting_building_fuel_oil_intensity *
                  characteristics[:area] *
                  characteristics[:duration] / 3600.0
            end
          end
          
          #### Electricity use (*kWh*)
          # *The meeting's electricity use.*
          committee :electricity_use do
            # Multiply the `census division` meeting building electricity intensity (*kWh / m<sup>2</sup> hour*) by `area` (*m<sup>2</sup>*) and `duration` (*seconds*) / 3600 (*seconds / hour*) to give *kWh*.
            quorum 'from census division, area, and duration', :needs => [:census_division, :area, :duration],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:census_division].meeting_building_electricity_intensity *
                  characteristics[:area] *
                  characteristics[:duration] / 3600.0
            end
          end
          
          #### District heat use (*MJ*)
          # *The meeting's district heat use.*
          committee :district_heat_use do
            # Multiply the `census division` meeting building district heat intensity (*MJ / m<sup>2</sup> hour*) by `area` (*m<sup>2</sup>*) and `duration` (*seconds*) / 3600 (*seconds / hour*) to give *MJ*.
            quorum 'from census division, area, and duration', :needs => [:census_division, :area, :duration],
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:census_division].meeting_building_district_heat_intensity *
                  characteristics[:area] *
                  characteristics[:duration] / 3600.0
            end
          end
          
          #### eGRID subregion
          # *The meeting venue's [eGRID subregion](http://data.brighterplanet.com/egrid_subregions).*
          committee :egrid_subregion do
            # Look up the `zip code` eGRID subregion.
            quorum 'from zip code', :needs => :zip_code,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:zip_code].egrid_subregion
            end
          end
          
          #### Census division
          # *The meeting venue's [census division](http://data.brighterplanet.com/census_divisions).*
          committee :census_division do
            # Look up the `state` census division.
            quorum 'from state', :needs => :state,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:state].census_division
            end
            
            # Otherwise uses an artificial census division representing U.S. averages.
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                CensusDivision.fallback
            end
          end
          
          #### State
          # *The meeting venue's [state](http://data.brighterplanet.com/states).*
          committee :state do
            # Use client input, if available.
            
            # Otherwise look up the `zip code` state.
            quorum 'from zip code', :needs => :zip_code,
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do |characteristics|
                characteristics[:zip_code].state
            end
          end
          
          #### Zip code
          # *The [zip code](http://data.brighterplanet.com/zip_codes) of the meeting venue.*
          #
          # Use client input, if available.
          
          #### Area (*m<sup>2</sup>*)
          # *The meeting venue's area.*
          committee :area do
            # Use client input, if available.
            
            # Otherwise use 1,184.5 *m<sup>2</sup>* (the average size of meeting buildings in the [EIA Commercial Building Energy Consumption Survey](http://data.brighterplanet.com/commercial_building_energy_consumption_survey_responses)).
            quorum 'default',
              :complies => [:ghg_protocol_scope_3, :iso, :tcr] do
                10_448.square_feet.to(:square_metres)
            end
          end
          
          #### Duration (*seconds*)
          # *The meeting's duration - the length of time the meeting facilities are in use. For example a two-day conference that runs 8 hours each day would have a duration of 57600.*
          committee :duration do
            # Uses client input, if available.
            
            # Otherwise use 28800 *seconds* (8 hours).
            quorum 'default' do
              28800.0
            end
          end
          
          #### Date (*date*)
          # *The day the meeting occurred.*
          committee :date do
            # Use client input, if available.
            
            # Otherwise use the first day of `timeframe`.
            quorum 'from timeframe',
              :complies => [:ghg_protocol_scope_3, :iso] do |characteristics, timeframe|
                timeframe.from
            end
          end
        end
      end
    end
  end
end
