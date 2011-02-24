require 'emitter'

module BrighterPlanet
  module Meeting
    extend BrighterPlanet::Emitter
    scope 'The meeting emission estimate is the anthropogenic emissions from meeting building energy use. It includes CO2 emissions from direct fuel combustion and indirect fuel combustion to generate electricity.'
  end
end
