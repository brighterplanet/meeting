require 'active_record'
require 'falls_back_on'
require 'meeting'
require 'sniff'

class MeetingRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::Meeting
  
  belongs_to :zip_code, :foreign_key => 'zip_code_name'
  belongs_to :state, :foreign_key => 'state_postal_abbreviation'
  
  falls_back_on :area     => 12_750.square_feet.to(:square_metres), # assume median-sized meeting building
                :duration => 8                                      # assume 1 day
end
