module AdminHelper
  def member_records
    MembershipBase::Members.all(sort: {'Pseudonym' => 'asc'})
      .map { |m| [ m['Pseudonym'], m.id ] }
  end

  def select_record_link(user, members)
    select(
      'update_user_link',
      user.id,
      options_for_select(
        @members,
        user.record_link || 'No Record Linked'
      ),
      {include_blank: 'No Record Linked'},
      {class: 'form-control'}
    )
  end
end
