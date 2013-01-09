require "spec_helper"

describe User do
  it { should belong_to(:account) }
  it { should have_many(:application_users) }
  it { should have_many(:applications).through(:application_users) }

  describe "validations" do
    let(:account) { Account.first }
    subject { FactoryGirl.build(:user) }

    xit "should require an account" do
      subject.account = nil
      should_not be_valid
      should have(1).error_on(:account)

      subject.account = account
      should be_valid
    end

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

    subject { FactoryGirl.build(:user) }

    describe "on create" do
      it "should assign a token" do
        SecureRandom.stub(:hex).and_return("my secure random")

        subject.tap(&:save!).reload

        subject.token.should == "my secure random"
      end
    end

    describe "passwords" do
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

  describe "#valid_password?" do
    let(:password) { "the password" }

    subject { FactoryGirl.create(:user, :password => password) }

    it "should not be valid (value)" do
      should_not be_valid_password("some password")
    end

    it "should be valid (actual password)" do
      should be_valid_password(password)
    end
  end

  describe "#update_token" do
    subject { FactoryGirl.build(:user) }

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
