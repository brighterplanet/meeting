require 'sniff/database'

Sniff::Database.define_schema do
  create_table "meeting_records", :force => true do |t|
    t.float  'something'
  end
end
