require "spec_helper"

describe ApplicationDecorator do
  let(:application) { FactoryGirl.build(:application) }
  let(:allowed) { [:name] }

  subject { ApplicationDecorator.new(application) }

  it_behaves_like "a decorator"

  describe "#save" do
    it "should save the application" do
      application.should_receive(:save)

      subject.save
    end

    it "should return the status of the save" do
      application.stub(:save).and_return("a saved model")

      subject.save.should == "a saved model"
    end
  end
end
