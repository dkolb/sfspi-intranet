module MembershipBase
  class EmergencyContacts < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Emergency Contacts'
  end
end
