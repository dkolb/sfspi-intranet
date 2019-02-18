class CalendarEvent < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Calendar Events'

  has_many :point_members,
    class: 'Member',
    column: 'Point Members'

  map_field :point_members_raw, 'Point Members'

  map_field :name, 'Name'
  map_field :location, 'Location'
  map_datetime_field :start_time, 'Start Time'
  map_datetime_field :end_time, 'End Time'
  map_checkbox_field :approved, 'Approved'

  validates_presence_of :name, :location, :start_time, :end_time, :start_time,
    :end_time
  
  validates_presence_of :point_members_raw,
    message: 'must select at least one'

  validate :dates_make_sense?

  private

  def dates_make_sense?
    return if [start_time.blank?, end_time.blank?].any?
    if start_time > end_time
      errors.add(:start_time, 'must be before the end time')
    end
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
end
