module BrighterPlanet
  module Meeting
    module Relationships
      def self.included(base)
        base.belongs_to :zip_code, :foreign_key => 'zip_code_name'
        base.belongs_to :state, :foreign_key => 'state_postal_abbreviation'
      end
    end
  end
end
