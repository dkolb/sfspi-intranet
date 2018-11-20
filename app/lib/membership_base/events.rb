module MembershipBase
  class Events < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Events'

    has_one :reporting_member,
      class: 'MembershipBase::Members',
      column: 'Reporting Member'

    has_many :point_members,
      class: 'MembershipBase::Members',
      column: 'Point Members'

    has_many :attendees,
      class: 'MembershipBase::Members',
      column: 'Attendees'
  end
end
