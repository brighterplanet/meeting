require 'characterizable'

module BrighterPlanet
  module Meeting
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :area     # square metres
          has :duration # hours
          has :zip_code
          has :state
        end
        base.add_implicit_characteristics
      end
    end
  end
end
