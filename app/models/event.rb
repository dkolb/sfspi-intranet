class Event < Airrecord::Table

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

  map_date_field :date, 'Date'
  map_field :name, 'Name of Event'
  map_field :venue, 'Venue'
  map_field :purpose, 'Purpose of Event'
  map_field :successes, 'Event Successes'
  map_field :challenges, 'Event Challenges'
  map_field :point_members_raw, 'Point Members'
  map_field :attendees_raw, 'Attendees'
  map_field :reporting_member_raw, 'Reporting Member'
  map_field :if_last_12_months, 'If Last 12 Months', read_only: true
  map_checkbox_field :form_filed, 'Form Filed?'

  def last_12_months?
    self['If Last 12 Months'] == 1
  end

  validates_presence_of :name, :venue

  validates_presence_of :point_members_raw, :attendees_raw, 
    message: "must select at least one"

  validates_format_of :date, 
    with: /\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])/,
    message: 'needs to be in YYYY-MM-DD format'


  def self.for_month(date)
    start_date = date.beginning_of_month - 6.days
    end_date = date.end_of_month + 6.days
    self.all(
      filter: 
        "AND(" \
        "IS_BEFORE({Date},DATETIME_PARSE('#{end_date.iso8601}')),"\
        "IS_AFTER({Date},DATETIME_PARSE('#{start_date.iso8601}'))" \
        ")"
    )
  end

  def self.for_date(date)
    Rails.logger.info('Trying to get dates for query with #{date}')
    self.all(filter: "{Date} = DATETIME_PARSE('#{date}')")
  end
end
