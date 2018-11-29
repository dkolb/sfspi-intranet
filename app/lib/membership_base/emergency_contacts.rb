module MembershipBase
  class EmergencyContacts < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Emergency Contacts'

    has_one :member,
      class: 'MembershipBase::Members',
      column: 'Member'
  end
end
