module MembershipBase
  class Members < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Members'

    has_many :paths,
      class: 'MembershipBase::Paths',
      column: "Path"

    has_many :events_attended,
      class: 'MembershipBase::Events',
      column: 'Events Attended'

    has_many :events_pointed,
      class: 'MembershipBase::Events',
      column: 'Events Pointed'

    has_many :meetings_attended,
      class: 'MembershipBase::Meetings',
      column: 'Meetings Attended'

    has_one :emergency_contact,
      class: 'MembershipBase::EmergencyContacts',
      column: 'Emergency Contact'
  end
end
