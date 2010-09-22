module BrighterPlanet
  module Meeting
    module Fallback
      def self.included(base)
        base.falls_back_on :area     => 12_750.square_feet.to(:square_metres), # assume median-sized meeting building
                           :duration => 8                                      # assume 1 day
      end
    end
  end
end
