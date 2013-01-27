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

    [:open, :resolved].each do |status|
      it "should allow #{status} for status" do
        subject.status = "invalid-status"
        should_not be_valid
        should have(1).error_on(:status)

        subject.status = status.to_s
        should be_valid
      end
    end
  end

  describe "#save" do
    let(:application) { Application.first }

    subject { FactoryGirl.build(:event, :application => application) }

    describe "latest event cache" do
      let(:key) { "#{subject.generated_at.to_i}:#{subject.id}" }

      def values
        Hat.redis {|r| r.hvals("applications:#{application.id}:events") }
      end

      def values_env
        Hat.redis {|r| r.hvals("applications:#{application.id}:events:#{subject.env}") }
      end

      def hget(key)
        Hat.redis {|r| r.hget("applications:#{application.id}:events", key) }
      end

      def hget_env(key)
        Hat.redis {|r| r.hget("applications:#{application.id}:events:#{subject.env}", key) }
      end

      it "should add the event to the events hash" do
        subject.save!

        values.should include(key)
      end

      it "should add the event to the events hash by environment" do
        subject.save!

        values_env.should include(key)
      end

      it "should key into by error class" do
        subject.save!

        hget(subject.klass).should == key
      end

      it "should key into by error class by environment" do
        subject.save!

        hget_env(subject.klass).should == key
      end
    end
  end

  describe "#resolved?" do
    it { should_not be_resolved }

    describe "when the status is resolved" do
      before do
        subject.status = "resolved"
      end

      it { should be_resolved }
    end
  end

  describe "#flagged?" do
    it { should_not be_flagged }

    describe "when flagged" do
      before do
        subject.flagged = true
      end

      it { should be_flagged }
    end
  end
end
