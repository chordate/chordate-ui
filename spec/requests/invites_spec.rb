require "spec_helper"

describe :invites, :js => true do
  let(:user) { User.first }
  let(:application) { Application.first }

  describe "for logged in users" do
    before do
      sign_in user
    end

    it "invites users" do
      before = { :i => Invite.count.to_i, :m => ActionMailer::Base.deliveries.size.to_i }

      visit_and_expect application_path(application)

      find_by_title(I18n.t("applications.show.invite_users")).click

      email = "new-john@example.com"
      fill_in I18n.t("common.email"), :with => email
      click_button I18n.t("buttons.invite")

      page.should have_content(I18n.t("invites.new.success"))
      page.should have_selector(".success")
      page.should_not have_selector(".success.hidden")

      # and for another email
      email = "other-john@example.com"
      fill_in I18n.t("common.email"), :with => email
      click_button I18n.t("buttons.invite")

      page.should have_content(I18n.t("invites.new.success", :email => email))
      page.should have_selector(".success")
      page.should_not have_selector(".success.hidden")

      (Invite.count.to_i - before[:i]).should == 2
      (ActionMailer::Base.deliveries.size.to_i - before[:m]).should == 2
    end
  end

  it "responds to an invite (existing user)" do
    other_user = FactoryGirl.create(:user)
    application.users = [other_user]

    invite = FactoryGirl.create(:invite, :email => user.email, :user => other_user, :application => application)
    visit application_invite_path(application, invite, :token => invite.token)

    expect_path application_path(application)
  end

  it "responds to an invite (existing logged-in user)" do
    other_user = FactoryGirl.create(:user)
    application.users = [other_user]

    sign_in other_user

    invite = FactoryGirl.create(:invite, :email => user.email, :user => other_user, :application => application)
    visit application_invite_path(application, invite, :token => invite.token)

    expect_path application_path(application)
  end

  it "responds to an invite (new user)" do
    email = "a-new-email@example.com"
    User.where(:email => email).count.should == 0

    invite = FactoryGirl.create(:invite, :email => email, :user => user, :application => application)

    visit application_invite_path(application, invite, :token => invite.token)
    current_url.should match(/token=#{invite.token}/)

    fill_in I18n.t("common.name"), :with => "my name"
    fill_in I18n.t("common.password"), :with => "password"
    click_button I18n.t("buttons.submit")

    expect_path application_path(application)

    User.where(:email => email).count.should == 1
  end
end
