require 'active_record'
require 'falls_back_on'
require 'meeting'
require 'sniff'

class MeetingRecord < ActiveRecord::Base
  include Sniff::Emitter
  include BrighterPlanet::Meeting
end
