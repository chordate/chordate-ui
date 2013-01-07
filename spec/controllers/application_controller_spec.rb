require "spec_helper"

describe ApplicationController do
  context "#current_user" do
    let(:user) { User.first }

    before do
      cookies.signed[:token] = user.token
    end

    it "should load the user" do
      controller.current_user.should == user
    end

    it "should cache the user" do
      User.should_receive(:where).with(:token => user.token).exactly(1).and_return([user])

      3.times { controller.current_user }
    end
  end

  describe "#set_cookie" do
    before do
      item = mock("item", :token => "The Token!")
      controller.instance_variable_set(:@item, item)
    end

    it "should return true" do
      controller.set_cookie.should == true
    end
  end
end
