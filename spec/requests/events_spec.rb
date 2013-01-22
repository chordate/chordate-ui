require "spec_helper"

describe :events, :js => true do
  let(:user) { User.first }
  let(:application) { Application.first }

  before do
    sign_in user
  end

  it "lists events" do
    options = {
      :env => "prod_env",
      :message => "A verbose exception message",
      :application => application
    }

    events = [
      FactoryGirl.create(:event, options.merge(:klass => "AnErrorClass")),
      FactoryGirl.create(:event, options.merge(:klass => "AnotherTypeOfError"))
    ]

    visit_and_expect application_events_path(application)

    page.should have_content(I18n.t("events.index.title"))

    within "#event_#{events.first.id}" do
      page.should have_content("prod_env")
      page.should have_content("AnErrorClass")
      page.should have_content("A verbose exception message")
    end

    within "#event_#{events.last.id}" do
      page.should have_content("prod_env")
      page.should have_content("AnotherTypeOfError")
      page.should have_content("A verbose exception message")
    end
  end

  it "groups events by type" do
    options = {
      :klass => "Error",
      :application => application
    }

    date = Time.now.end_of_year
    events = [
      FactoryGirl.create(:event, options.merge(:generated_at => date - 1.day)),
      FactoryGirl.create(:event, options.merge(:generated_at => date + 1.hour - 30.seconds, :message => "Custom message!"))
    ]

    visit application_events_path(application)

    within "#event_#{events.last.id}" do
      page.should have_content("Custom message!")
    end

    page.should_not have_selector("#event_#{events.first.id}")
  end
end
