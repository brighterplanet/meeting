require 'data_miner'

module BrighterPlanet
  module Meeting
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            float  'area'
            float  'duration'
            string 'zip_code_name'
            string 'state_postal_abbreviation'
          end
          
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
