require 'summary_judgement'

module BrighterPlanet
  module Meeting
    module Summarization
      def self.included(base)
        base.extend SummaryJudgement
        base.summarize do |has|
          has.identity 'meeting'
        end
      end
    end
  end
end
