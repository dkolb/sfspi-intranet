require "application_system_test_case"

class CalendarEventsTest < ApplicationSystemTestCase
  setup do
    @calendar_event = calendar_events(:one)
  end

  test "visiting the index" do
    visit calendar_events_url
    assert_selector "h1", text: "Calendar Events"
  end

  test "creating a Calendar event" do
    visit calendar_events_url
    click_on "New Calendar Event"

    click_on "Create Calendar event"

    assert_text "Calendar event was successfully created"
    click_on "Back"
  end

  test "updating a Calendar event" do
    visit calendar_events_url
    click_on "Edit", match: :first

    click_on "Update Calendar event"

    assert_text "Calendar event was successfully updated"
    click_on "Back"
  end

  test "destroying a Calendar event" do
    visit calendar_events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Calendar event was successfully destroyed"
  end
end
