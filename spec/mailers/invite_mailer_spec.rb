require "spec_helper"

describe InviteMailer do
  let(:user) { User.first.tap {|u| u.update_column(:name, "John Doe") } }
  let(:application) { Application.first }

  describe ".invited" do
    let(:invite) { FactoryGirl.create(:invite, :user => user, :application => application) }

    subject { @email ||= InviteMailer.invited(invite.id).deliver }

    it "should send email" do
      expect {
        subject
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "should email the invitee" do
      subject.to.should == [invite.email]
    end

    it "should have the subject" do
      subject.subject.should == I18n.t("invite.mailer.invited.subject")
    end

    it "should have the body" do
      subject.body.should match(/join #{application.name}/)
      subject.body.should match(/by John Doe/)
      subject.body.should match(/applications\/#{application.id}\/invites\/#{invite.id}/)
      subject.body.should match(/token=#{invite.token}/)
    end
  end
end
