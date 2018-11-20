module MembershipBase
  class Meetings < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Meetings'
  end
end
