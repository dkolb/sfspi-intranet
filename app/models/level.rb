class Level < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Levels'

  map_field :name, 'Name'

  has_many :members,
    class: 'Member',
    column: 'Members'

  map_field :members_raw, 'Members'

  def self.level_map
    Level.all.each_with_object({}) do |level, level_map|
      level_map[level.id] = level
    end
  end
end
