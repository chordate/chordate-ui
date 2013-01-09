module RequestHelper
  def expect_path(path)
    wait_until(2) { current_path == path }

    current_path.should == path
  end

  def sign_in(user, options = {})
    visit new_session_path

    fill_in I18n.t("sessions.new.email"), :with => user.email
    fill_in I18n.t("sessions.new.password"), :with => "password"

    click_button I18n.t("buttons.submit")

    expect_path dashboard_path
    visit (options[:to] || dashboard_path)
  end
end
