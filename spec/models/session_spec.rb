require "spec_helper"

describe Session do
  let(:password) { "password" }
  let(:user) { FactoryGirl.create(:user, :password => password) }

  subject { Session.new(:email => user.email) }

  it "should expose the user" do
    subject.user.should == user
  end

  it "should expose the token" do
    subject.token.should == user.token
  end

  describe "#login" do
    subject { Session.new(:email => user.email, :password => password) }

    def login
      subject.login
    end

    it "should change the session token" do
      before = user.token
      login

      user.reload.token.should_not == before
    end

    it "should return true" do
      login.should == true
    end

    describe "when given the wrong password" do
      subject { Session.new(:email => user.email, :password => "wrong password") }

      it "should not change the token" do
        before = user.token
        login

        user.reload.token.should == before
      end

      it "should return false" do
        login.should == false
      end
    end

    describe "when given an invalid email" do
      subject { Session.new(:email => "random_#{user.email}") }

      it "should return false" do
        login.should == false
      end
    end
  end
end
