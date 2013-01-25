require "spec_helper"

describe Invite do
  it { should belong_to(:user) }
  it { should belong_to(:application) }

  describe "validations" do
    subject { FactoryGirl.build(:invite) }

    it "should require a email" do
      should be_valid
      subject.email = nil

      should_not be_valid
      should have(1).error_on(:email)
    end

    it "should require a user" do
      should be_valid
      subject.user = nil

      should_not be_valid
      should have(1).error_on(:user)
    end

    it "should require a application" do
      should be_valid
      subject.application = nil

      should_not be_valid
      should have(1).error_on(:application)
    end
  end

  describe "#save" do
    describe "on create" do
      subject { FactoryGirl.build(:invite) }

      before do
        SecureRandom.stub(:hex).and_return("THE TOKEN!")
      end

      it "should generate a token" do
        SecureRandom.should_receive(:hex).with(24)

        subject.save!
      end

      it "should store the token" do
        subject.tap(&:save!).reload

        subject.token.should == "THE TOKEN!"
      end
    end
  end
end
