require "spec_helper"

describe Account do
  it { should have_many(:users) }
  it { should have_one(:owner).class_name(User) }

  describe "#owner" do
    let(:other_user) { FactoryGirl.create(:user, :account => subject) }

    subject { FactoryGirl.create(:account) }

    it "should be nil" do
      subject.owner.should == nil
    end

    describe "when a user has been added" do
      before do
        subject.users << other_user
      end

      it "should be the owner" do
        subject.owner.should == other_user
      end
    end
  end
end
