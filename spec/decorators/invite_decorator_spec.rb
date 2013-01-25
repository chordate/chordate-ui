require "spec_helper"

describe InviteDecorator do
  let(:invite) { FactoryGirl.create(:invite) }
  let(:allowed) { [:email, :token, :shown] }

  subject { InviteDecorator.new(invite) }

  it_behaves_like "a decorator"

  describe "#application" do
    it "should expose the invite's application" do
      invite.application.should_not be_nil

      subject.application.should == invite.application
    end
  end

  describe "#save" do
    let(:invite) { FactoryGirl.build(:invite) }

    it "should save the user" do
      invite.should_receive(:save)

      subject.save
    end

    it "should return the status of the save" do
      invite.stub(:save).and_return("a saved model")

      subject.save.should == "a saved model"
    end

    it "should email the invitee" do
      InviteMailer.should_receive(:invited) do |*args|
        raise MockExpectationError.new("InviteMailer#invited should be called with the invite id") unless args.first == invite.id

        mock(InviteMailer, :deliver => nil)
      end

      subject.save
    end

    describe "when the invite does not save" do
      before do
        invite.stub(:persisted?).and_return(false)
      end

      it "should not email the invitee" do
        InviteMailer.should_not_receive(:invited)

        subject.save
      end
    end
  end

  describe "#create" do
    def create
      subject.create(:name => "my name", :password => "my password")
    end

    it "should create a new user" do
      invite

      expect{
        create
      }.to change(User, :count).by(1)
    end

    it "should be created" do
      create

      should be_created
    end

    it "should return the user" do
      create.should == User.last
    end

    it "should store the given name" do
      create

      User.last.name.should == "my name"
    end

    it "should store the given password" do
      create

      User.last.valid_password?("my password").should == true
    end

    it "should have the application's account" do
      create

      User.last.account.should == invite.application.account
    end

    it "should be a member of the application" do
      create

      invite.application.users.should include(User.last)
    end

    describe "when the user exists" do
      before do
        @user = FactoryGirl.create(:user, :email => invite.email)
      end

      it "should return the user" do
        create.should == @user
      end

      it "should not be created" do
        create

        should_not be_created
      end

      describe "when the user is part of the application" do
        before do
          invite.application.users << @user
        end

        it "should return the user" do
          create.should == @user
        end

        it "should not be created" do
          create

          should_not be_created
        end
      end
    end
  end

  describe "#redeem" do
    before do
      invite.application.users << invite.user
    end

    it "should be true" do
      subject.redeem.should == true
    end

    it "should set the shown time" do
      Timecop.freeze(DateTime.now) do
        subject.redeem

        invite.shown.should == Time.now
      end
    end

    describe "when a user exists with the invite's email" do
      before do
        @user = FactoryGirl.create(:user, :email => invite.email)
      end

      it "should be true" do
        subject.redeem.should == true
      end

      it "should add the user to the application" do
        invite.application.users.should_not include(@user)
        subject.redeem

        invite.application.users.should include(@user)
      end
    end

    describe "when the invite has been redeemed" do
      before do
        subject.redeem
      end

      it "should update the shown time" do
        Timecop.freeze(DateTime.now) do
          subject.redeem

          invite.reload.shown.to_i.should == Time.now.to_i
        end
      end
    end

    describe "when the invite cannot be redeemed" do
      before do
        invite.application.users = []
      end

      it "should be false" do
        subject.redeem.should == false
      end

      it "should not update the shown time" do
        before = invite.shown
        subject.redeem

        invite.reload.shown.should == before
      end
    end

    describe "when not given an invite" do
      subject { InviteDecorator.new(nil) }

      it "should be false" do
        subject.redeem.should == false
      end
    end
  end

  describe "#user?" do
    before do
      invite.application.users << invite.user
    end

    it "should be false" do
      subject.user?.should == false
    end

    describe "after redemption" do
      before do
        subject.redeem
      end

      it "should be false" do
        subject.user?.should == false
      end

      describe "when a user exists with the email" do
        before do
          FactoryGirl.create(:user, :email => invite.email)

          subject.redeem
        end

        it "should be true" do
          subject.user?.should == true
        end
      end
    end
  end

  describe "#user" do
    before do
      invite.application.users << invite.user
    end

    it "should not have a user" do
      subject.user.should == nil
    end

    describe "after redemption" do
      before do
        subject.redeem
      end

      it "should not have a user" do
        subject.user.should == nil
      end

      describe "when a user exists (was found by) with the email" do
        before do
          @user = FactoryGirl.create(:user, :email => invite.email)

          subject.redeem
        end

        it "should be that user" do
          subject.user.should == @user
        end
      end
    end
  end
end
