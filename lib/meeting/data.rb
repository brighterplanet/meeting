module BrighterPlanet
  module Meeting
    module Data
      def self.included(base)
        base.force_schema do
          float  'area'
          float  'duration'
          string 'zip_code_name'
          string 'state_postal_abbreviation'
        end
      end
    end
  end
end
