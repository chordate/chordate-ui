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

  describe ".recent" do
    let(:application) { Application.first }

    def recent(app)
      Event.recent(app)
    end

    before do
      @events = [
        FactoryGirl.create(:event, :klass => "FirstError", :application => application),
        FactoryGirl.create(:event, :klass => "LastError", :application => application)
      ]
    end

    it "should return the events" do
      recent(application).should == @events
    end

    describe "when there are events with the same class" do
      before do
        @events.push(
          FactoryGirl.create(:event, :klass => "FirstError", :generated_at => 1.minute.from_now, :application => application)
        )
      end

      it "should return the most recent events" do
        recent(application).should == @events.last(2)
      end
    end

    describe "when given an environment" do
      def recent(app)
        Event.recent(app, "the_env")
      end

      before do
        @other_event = FactoryGirl.create(:event, :env => "the_env", :application => application)
      end

      it "should only return events from that environment" do
        recent(application).should == [@other_event]
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
end
