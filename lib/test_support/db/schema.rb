require 'sniff/database'

Sniff::Database.define_schema do
  create_table "meeting_records", :force => true do |t|
    t.float  'duration'
    t.float  'area'
    t.string 'zip_code_name'
    t.string 'state_postal_abbreviation'
  end
end
