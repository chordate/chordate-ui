require "spec_helper"

describe Api::ErrorDecorator do
  subject { Api::ErrorDecorator.new(500, ["A Message"]) }

  describe "#code" do
    it "should be the given code" do
      subject.code.should == 500
    end
  end

  describe "#message" do
    it "should be the given message" do
      subject.messages.should == ["A Message"]
    end
  end

  describe "#as_json" do
    it "should format the error information" do
      subject.as_json.should == {
        :error => {
          :code => 500,
          :messages => ["A Message"]
        }
      }
    end
  end
end
