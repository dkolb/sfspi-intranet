module MembershipBase
  class Event < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Events'

    has_one :reporting_member,
      class: 'MembershipBase::Member',
      column: 'Reporting Member'

    has_many :point_members,
      class: 'MembershipBase::Member',
      column: 'Point Members'

    has_many :attendees,
      class: 'MembershipBase::Member',
      column: 'Attendees'

      map_field :date, 'Date'
      map_field :name, 'Name of Event'
      map_field :venue, 'Venue'
      map_field :purpose, 'Purpose of Event'
      map_field :successes, 'Event Successes'
      map_field :challenges, 'Event Challenges'
      map_field :point_members, 'Point Members'
      map_field :attendees, 'Attendees'
      map_field :form_filed, 'Form Filed'
  end
end
