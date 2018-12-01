module MembershipBase
  class Path < Airrecord::Table
    self.base_key = ENV['AIRTABLE_APP_KEY']
    self.table_name = 'Paths'

    has_many :members, class: "MembershipBase::Members", column: "Members"
  end
end
