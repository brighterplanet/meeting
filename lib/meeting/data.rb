module BrighterPlanet
  module Meeting
    module Data
      def self.included(base)
        base.col :date, :type => :date
        base.col :area, :type => :float
        base.col :duration, :type => :float
        base.col :zip_code_name
        base.col :state_postal_abbreviation
      end
    end
  end
end