module BrighterPlanet
  module Meeting
    module Characterization
      def self.included(base)
        base.characterize do
          has :date
          has :area, :measures => Measurement::Area
          has :duration, :measures => :time
          has :zip_code
          has :state
        end
      end
    end
  end
end
