require "spec_helper"

describe User do
  subject { FactoryGirl.build(:user) }

  context "validations" do
    it "should require a name" do
      subject.name = nil
      should_not be_valid
      should have(1).error_on(:name)

      subject.name = "John"
      should be_valid
    end

    it "should require an email" do
      subject.email = nil
      should_not be_valid
      should have(1).error_on(:email)

      subject.email = "john-doe@example.com"
      should be_valid
    end

    it "should require a password" do
      subject.password = nil
      should_not be_valid
      should have(1).error_on(:password)

      subject.password = "a password"
      should be_valid
    end
  end

  describe "#save" do
    let(:password) { "my password" }

    context "on create" do
      it "should assign a token" do
        SecureRandom.stub(:hex).and_return("my secure random")

        subject.tap(&:save!).reload

        subject.token.should == "my secure random"
      end
    end

    context "passwords" do
      before do
        subject.password = password
      end

      it "should salt the current time" do
        Timecop.freeze(DateTime.now) do
          subject.tap(&:save!).reload

          subject.salt.should == Time.now.to_i
        end
      end

      it "should not store the exact value" do
        subject.tap(&:save!).reload

        subject.password.should_not == password
      end
    end
  end

  context "#valid_password?" do
    let(:password) { "the password" }
    subject { FactoryGirl.create(:user, :password => password) }

    it "should not be valid (value)" do
      should_not be_valid_password("some password")
    end

    it "should be valid (actual password)" do
      should be_valid_password(password)
    end
  end

  context "#update_token" do
    before do
      subject.save!
    end

    it "should change the token" do
      expect {
        subject.update_token
      }.to change(subject.reload, :token)
    end
  end
end
