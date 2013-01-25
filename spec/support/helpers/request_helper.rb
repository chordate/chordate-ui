module RequestHelper
  def visit_and_expect(path)
    visit path

    expect_path path
  end

  def expect_path(path)
    wait_until(2) { current_path == path }

    current_path.should == path
  end

  def sign_in(user, options = {})
    visit new_session_path

    fill_in I18n.t("common.email"), :with => user.email
    fill_in I18n.t("common.password"), :with => "password"

    click_button I18n.t("buttons.login")

    expect_path dashboard_path
    visit (options[:to] || dashboard_path)
  end

  def find_by_title(title)
    page.find('a', :title => title)
  end
end
