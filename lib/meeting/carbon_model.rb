require 'leap'
require 'conversions'

module BrighterPlanet
  module Meeting
    module CarbonModel
      def self.included(base)
        base.extend ::Leap::Subject
        base.decide :emission, :with => :characteristics do
          committee :emission do # returns kg CO2e
            quorum 'from default' do |characteristics|
              100.0
            end
            
            quorum 'default' do
              raise "The emission committee's default quorum should never be called"
            end
          end
        end
      end
    end
  end
end
