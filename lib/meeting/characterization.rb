module BrighterPlanet
  module Meeting
    module Characterization
      def self.included(base)
        base.characterize do
          has :area     # square metres
          has :duration # hours
          has :zip_code
          has :state
        end
      end
    end
  end
end
