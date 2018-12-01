module EventsHelper
  def events_for_date(date)
    events = MembershipBase::Event.all(
      filter: "{Date} = DATETIME_PARSE('#{date}')"
    )

    events.map do |e|
      {
        name: e['Name of Event'],
        venue: e['Venue']
      }
    end
  end

  def active_member_records
    @active_member_records ||= MembershipBase::Member.all(
      filter: '{Status} = "Active"',
      sort: {'Pseudonym' => 'asc'}
    )
  end
end
