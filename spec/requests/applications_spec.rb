require "spec_helper"

describe "applications", :js => true do
  let(:user) { User.first }

  before do
    sign_in user, :to => new_application_path
  end

  it "creates a new app" do
    fill_in I18n.t("applications.new.name"), :with => "App Name 1"

    click_button I18n.t("buttons.create")

    expect_path applications_path

    page.should have_content I18n.t("applications.index.title")

    app = Application.last
    app.name.should == "App Name 1"
    app.token.should_not be_blank

    within "#application_#{app.id}" do
      page.should have_content(app.name)
      page.should have_content(app.token)
    end
  end

  it "navigates to an application detail" do
    apps = FactoryGirl.create_list(:application, 2)
    apps.each {|app| app.users << user }

    other_app = FactoryGirl.create(:application)
    other_app.users = []

    app  = apps.first

    visit applications_path

    page.should_not have_selector "#application_#{other_app.id}"

    page.should have_selector "#application_#{apps.first.id}"
    page.should have_selector "#application_#{apps.last.id}"

    within "#application_#{app.id}" do
      click_link app.name
    end

    expect_path application_path(app)

    # and again for the explicit button
    visit applications_path

    within "#application_#{app.id}" do
      click_link I18n.t("applications.index.go_to_app")
    end

    expect_path application_path(app)
  end
end
