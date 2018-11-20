module MeHelper
  def member_records
    MembershipBase::Members.all
      .map { |m| [ m['Pseudonym'], m.id ] }
  end
end
