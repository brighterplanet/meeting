require 'characterizable'

module BrighterPlanet
  module Meeting
    module Characterization
      def self.included(base)
        base.send :include, Characterizable
        base.characterize do
          has :something
        end
        base.add_implicit_characteristics
      end
    end
  end
end
