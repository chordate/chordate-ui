require "spec_helper"

describe UserDecorator do
  let(:user) { FactoryGirl.build(:user) }
  let(:allowed) { [:name, :email] }

  subject { UserDecorator.new(user) }

  it_behaves_like "a decorator"

  describe "#save" do
    it "should save the user" do
      user.should_receive(:save)

      subject.save
    end

    it "should return the status of the save" do
      user.stub(:save).and_return("a saved model")

      subject.save.should == "a saved model"
    end
  end
end
