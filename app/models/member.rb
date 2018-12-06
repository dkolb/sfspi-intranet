class Member < Airrecord::Table
  extend ActiveModel::Naming

  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Members'

  has_many :paths,
    class: 'Path',
    column: "Path"

  has_many :events_attended,
    class: 'Event',
    column: 'Events Attended'

  has_many :events_pointed,
    class: 'Event',
    column: 'Events Pointed'

  has_many :meetings_attended,
    class: 'Meeting',
    column: 'Meetings Attended'

  has_one :emergency_contact,
    class: 'EmergencyContact',
    column: 'Emergency Contact'

  map_field :full_name, 'Full Name'
  map_field :path, 'Path'
  map_field :pseudonym, 'Pseudonym'
  map_field :mobile_number, 'Mobile Number'
  map_field :email_address, 'E-Mail'
  map_field :address, 'Street Address'
  map_field :city, 'City'
  map_field :state, 'State'
  map_field :zip, 'Zip'
end
