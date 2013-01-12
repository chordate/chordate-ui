require "spec_helper"

describe Event do
  it { should belong_to(:application) }

  describe "validations" do
    subject { FactoryGirl.build(:event) }

    it "should require a klass" do
      subject.klass = nil
      should_not be_valid
      should have(1).error_on(:klass)

      subject.klass = "Yay"
      should be_valid
    end

    it "should require an env" do
      subject.env = nil
      should_not be_valid
      should have(1).error_on(:env)

      subject.env = "production"
      should be_valid
    end

    it "should require a generated_at" do
      subject.generated_at = nil
      should_not be_valid
      should have(1).error_on(:generated_at)

      subject.generated_at = Time.now
      should be_valid
    end

    it "should require an application" do
      subject.application = nil
      should_not be_valid
      should have(1).error_on(:application)

      subject.application = Application.first
      should be_valid
    end
  end
end
