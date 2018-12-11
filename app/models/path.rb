class Path < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'Paths'

  has_many :members, class: "Member", column: "Members"
  
  map_field :name, 'Name'

  def self.path_map
    Path.all.each_with_object({}) do |path, path_map|
      path_map[path.id] = path
    end
  end
end
