require "spec_helper"

describe "users" do
  it "creates a new user", :js => true do
    visit new_session_path

    click_link I18n.t("sessions.new.not_registered")

    fill_in I18n.t("users.new.name"), :with => "John Doe (a new user)"
    fill_in I18n.t("users.new.email"), :with => "john-a-new-user@example.com"
    fill_in I18n.t("users.new.password"), :with => "password"

    click_button I18n.t("buttons.submit")

    wait_until(2) { current_path == dashboard_path }

    current_path.should == dashboard_path

    user = User.last
    user.name.should == "John Doe (a new user)"
    user.email.should == "john-a-new-user@example.com"
    user.should be_valid_password("password")
  end

  it "logs in a user", :js => true do
    user = FactoryGirl.create(:user, :password => "a password")

    visit new_session_path

    fill_in I18n.t("sessions.new.email"), :with => user.email
    fill_in I18n.t("sessions.new.password"), :with => "a password"

    click_button I18n.t("buttons.submit")

    wait_until(2) { current_path == dashboard_path }

    current_path.should == dashboard_path
  end

  it "routes to the registration page" do
    visit dashboard_path

    current_path.should == new_session_path
  end
end
