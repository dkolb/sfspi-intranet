class Path < Airrecord::Table
  extend ActiveModel::Naming

  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Paths'

  has_many :members, class: "Member", column: "Members"
end
