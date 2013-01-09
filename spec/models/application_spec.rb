require "spec_helper"

describe Application do
  it { should belong_to(:account) }
  it { should belong_to(:user) }
  it { should have_many(:application_users) }
  it { should have_many(:users).through(:application_users) }

  describe "validations" do
    let(:account) { Account.first }
    let(:user) { User.first }

    subject { FactoryGirl.build(:application) }

    it "should require a user" do
      subject.user = nil
      should_not be_valid
      should have(1).error_on(:user)

      subject.user = user
      should be_valid
    end

    it "should require a name" do
      subject.name = nil
      should_not be_valid
      should have(1).error_on(:name)

      subject.name = "Application"
      should be_valid
    end
  end

  describe "#save" do
    describe "on create" do
      let(:user) { User.first }
      subject { FactoryGirl.create(:application, :user => user) }

      before do
        SecureRandom.stub(:hex).and_return("the random characters")
      end

      it "should generate an api token" do
        subject.token.should_not be_blank
      end

      it "should generate a random part" do
        SecureRandom.should_receive(:hex).with(9).and_return("")

        subject
      end

      it "should be the (generated time / user id) + random chars" do
        Timecop.freeze(DateTime.now) do
          subject.token.should == ("%010d%020d" % [Time.now.to_i, user.id]).to_i.to_s(36) + "the random characters"
        end
      end
    end
  end
end
