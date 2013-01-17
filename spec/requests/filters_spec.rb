require "spec_helper"

describe "filters", :js => true do
  let(:user) { User.first }
  let(:application) { Application.first }

  before do
    sign_in user
  end

  it "filters by error class" do
    events = FactoryGirl.create_list(:event, 2, :application => application)
    events << FactoryGirl.create(:event, :klass => events.last.klass, :application => application)

    visit_and_expect application_events_path(application)

    page.should have_selector("#event_#{events.first.id}")
    page.should_not have_selector("#event_#{events.second.id}")
    page.should have_selector("#event_#{events.last.id}")

    within "#filters" do
      within "#filter_klass" do
        page.should have_content(events.first.klass)
        page.should have_content(events.last.klass)

        find_by_title(events.first.klass).click
      end
    end

    page.should have_selector("#event_#{events.first.id}")
    page.should_not have_selector("#event_#{events.second.id}")
    page.should_not have_selector("#event_#{events.last.id}")
  end
end
