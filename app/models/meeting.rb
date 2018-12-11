class Meeting < Airrecord::Table
  MEETING_TYPE_MAP = {
    'GM' => 'General Meeting',
    'Board' => 'Board'
  }

  MEETING_SET_TYPE_MAP = MEETING_TYPE_MAP.invert

  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Meetings'

  map_field :type, 'Meeting Type'
  map_date_field :date, 'Date'
  map_field :attendees_raw, 'Attendees'

  has_many :attendees,
    class: 'Member',
    column: 'Attendees'

  validates :type, inclusion: MEETING_TYPE_MAP.keys
  validates :attendees_raw, presence: {message: 'must select at least one'}

  def last_12_months?
    self['If Last 12 Months'] == 1
  end

  def verbose_type
    MEETING_TYPE_MAP[type]
  end

  def verbose_type=(new_val)
    self.type = MEETING_SET_TYPE_MAP[new_val]
  end

  def allowed_verbose_types
    MEETING_SET_TYPE_MAP.keys
  end
end
