class Member < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Members'


  has_many :paths,
    class: 'Path',
    column: "Path"

  map_field :paths_raw, 'Path'

  has_one :level,
    class: 'Level',
    column: 'Level'

  map_field :level_raw, 'Level'

  has_many :events_attended,
    class: 'Event',
    column: 'Events Attended'

  map_field :events_attended_raw, 'Events Attended'

  has_many :events_pointed,
    class: 'Event',
    column: 'Events Pointed'

  map_field :events_pointed_raw, 'Events Pointed'

  has_many :meetings_attended,
    class: 'Meeting',
    column: 'Meetings Attended'

  map_field :meetings_attended_raw, 'Meetings Attended'

  has_one :emergency_contact,
    class: 'EmergencyContact',
    column: 'Emergency Contact'

  map_field :emergency_contact_raw, 'Emergency Contact'

  has_many :events_reported,
    calss: 'Event',
    column: 'Events Reported'

  map_field :events_reported_raw, 'Events Reported'

  map_field :full_name, 'Full Name'
  map_field :path, 'Path'
  map_field :pseudonym, 'Pseudonym'
  map_field :mobile_number, 'Mobile Number'
  map_field :email_address, 'E-Mail'
  map_field :address, 'Street Address'
  map_field :city, 'City'
  map_field :state, 'State'
  map_field :zip, 'Zip'

  class << self
    def yellow_pages_view
      path_map = Path.path_map
      level_map = Level.level_map
      Member.records(
        fields: ['Path', 'Level', 'Pseudonym', 'Mobile Number', 'E-Mail'],
        filter: '{Status} = "Active"',
        sort: { "Pseudonym" => "asc" }
      ).map do |m|
        YellowPageView.new(
          id: m.id,
          pseudonym: m.pseudonym,
          path: m.paths_raw.nil? ? nil : m.paths_raw.map { |p| path_map[p] },
          level: m.level_raw.nil? ? nil : level_map[m.level_raw[0]],
          mobile_number: m.mobile_number,
          email_address: m.email_address
        )
      end
    end

    private
    YellowPageView = Struct.new(
      :id,
      :pseudonym,
      :path,
      :level,
      :mobile_number,
      :email_address,
      keyword_init: true
    )
  end
end
