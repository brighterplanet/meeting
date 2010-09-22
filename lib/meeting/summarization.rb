module BrighterPlanet
  module Meeting
    module Summarization
      def self.included(base)
        base.summarize do |has|
          has.identity 'meeting'
        end
      end
    end
  end
end
