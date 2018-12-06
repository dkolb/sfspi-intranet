class Meeting < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Meetings'

  map_field :type, 'Meeting Type'
  map_field :date, 'Date'
  map_field :attendees_raw, 'Attendees'

  has_many :attendees,
    class: 'Member',
    column: 'Attendees'

  def last_12_months?
    self['If Last 12 Months'] == 1
  end
end
