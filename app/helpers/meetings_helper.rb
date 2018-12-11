module MeetingsHelper
  def member_records
    Member.all(sort: { 'Pseudonym' => 'asc' })
  end

  def can_edit?
    is_secretary? || is_admin?
  end
end
