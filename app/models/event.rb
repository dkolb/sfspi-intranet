class Event < Airrecord::Table
  include ActiveModel::Validations
  extend ActiveModel::Naming

  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Events'

  has_one :reporting_member,
    class: 'Member',
    column: 'Reporting Member'

  has_many :point_members,
    class: 'Member',
    column: 'Point Members'

  has_many :attendees,
    class: 'Member',
    column: 'Attendees'

  map_field :date, 'Date'
  map_field :name, 'Name of Event'
  map_field :venue, 'Venue'
  map_field :purpose, 'Purpose of Event'
  map_field :successes, 'Event Successes'
  map_field :challenges, 'Event Challenges'
  map_field :point_members_raw, 'Point Members'
  map_field :attendees_raw, 'Attendees'
  map_field :reporting_member_raw, 'Reporting Member'
  map_field :if_last_12_months, 'If Last 12 Months', read_only: true

  def last_12_months?
    self['If Last 12 Months'] == 1
  end

  def form_filed
    self['Form Filed?'] || true
  end

  def form_filed=(new_value)
    self['Form Filed?'] = new_value.to_s == "true"
  end

  validates_presence_of :name, :venue

  validates_presence_of :point_members, :attendees, 
    message: "must select at least one"

  validates_format_of :date, 
    with: /\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])/,
    message: 'needs to be in YYYY-MM-DD format'
end
