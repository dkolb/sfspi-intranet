class CalendarEvent < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Calendar Events'

  EVENT_TYPES = ['Event', 'Holiday']

  has_many :point_members,
    class: 'Member',
    column: 'Point Members'

  map_field :point_members_raw, 'Point Members'

  map_field :name, 'Name'
  map_field :location, 'Location'
  map_datetime_field :start_time, 'Start Time'
  map_datetime_field :end_time, 'End Time'
  map_checkbox_field :approved, 'Approved'
  map_checkbox_field :start_time_tbd, 'Start Time TBD'
  map_checkbox_field :end_time_tbd, 'End Time TBD'
  map_checkbox_field :all_day, 'All Day'
  map_field :type, 'Type'

  validates_presence_of :location, if: :is_event? 

  validates_presence_of :name, :start_time, :end_time
  
  validates_presence_of :point_members_raw,
    message: 'must select at least one', if: :is_event?

  validate :dates_make_sense?

  validates :type, inclusion: { in: EVENT_TYPES }

  def start_time_display
    if all_day || start_time_tbd
      date_display start_time 
    else
      time_display start_time 
    end
  end

  def end_time_display
    if all_day || end_time_tbd
      date_display end_time 
    else
      time_display end_time 
    end
  end

  def is_event?
    type == 'Event'
  end

  def is_holiday?
    type == 'Holiday'
  end

  def self.for_month(date)
    start_date = date.beginning_of_month - 6.days
    end_date = date.end_of_month + 6.days
    self.all(
      filter: 
        "AND(" \
        "IS_BEFORE({Start Time},DATETIME_PARSE('#{end_date.iso8601}')),"\
        "IS_AFTER({Start Time},DATETIME_PARSE('#{start_date.iso8601}'))" \
        ")"
    )
  end

  def self.for_year(year)
    start_date = Time.zone.local(year.to_i, 1, 1)
    end_date   = Time.zone.local(year.to_i, 12, 31)
    self.all(
      filter:
      "AND(" \
      "IS_BEFORE({Start Time}, DATETIME_PARSE('#{end_date.iso8601}')),"\
      "IS_AFTER({Start Time}, DATETIME_PARSE('#{start_date.iso8601}'))"\
      ")"
    )
  end

  # Arguments must respond to #iso8601
  def self.for_range(start_date, end_date)
    self.all(
      filter:
      "AND(" \
      "IS_BEFORE({Start Time}, DATETIME_PARSE('#{end_date.iso8601}')),"\
      "IS_AFTER({Start Time}, DATETIME_PARSE('#{start_date.iso8601}'))"\
      ")"
    )
  end

  def self.allowed_event_types
    EVENT_TYPES
  end

  private

  def dates_make_sense?
    return if [start_time.blank?, end_time.blank?].any?
    if start_time > end_time
      errors.add(:start_time, 'must be before the end time')
    end
  end

  def time_display(time)
    time.strftime('%B %-d, %Y %-I:%M %p %Z') unless time.nil?
  end

  def date_display(time)
    time.strftime('%B %-d, %Y') unless time.nil?
  end
end
