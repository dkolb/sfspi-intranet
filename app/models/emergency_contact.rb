class EmergencyContact < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Emergency Contacts'

  has_one :member,
    class: 'Members',
    column: 'Member'

  map_field :contact_name, 'Contact Name'
  map_field :address, 'Address'
  map_field :city, 'City'
  map_field :state, 'State'
  map_field :zip, 'Zip'
  map_field :cell_phone, 'Cell Phone'
  map_field :relationship, 'Relationship to Member'
end
