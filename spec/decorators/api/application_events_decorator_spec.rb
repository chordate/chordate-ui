require "spec_helper"

describe Api::ApplicationEventsDecorator do
  let(:application) { Application.first }
  let(:events) { 3.times.collect { create_event } }
  let(:options) { {} }

  subject { Api::ApplicationEventsDecorator.new(application) }

  def create_event
    {
      :env => "production",
      :klass => "Timeout::Error",
      :message => "Execution expired",
      :generated_at => Time.zone.now.beginning_of_day
    }.merge(options)
  end

  describe "#create" do
    def create
      subject.create(events)
    end

    it "should make events" do
      expect {
        create
      }.to change(Event, :count).by(3)
    end

    it "should be events for the application" do
      create

      Event.last(3).collect(&:application).uniq.should == [application]
    end

    it "should have the attributes" do
      create

      Event.last(3).collect(&:attributes).
        each {|event| event.slice(*%w(env klass message generated_at)).should == create_event.stringify_keys }
    end

    it "should return the events" do
      create.collect(&:as_json).should == Event.last(3).collect {|event| EventDecorator.new(event).as_json }
    end

    describe "when some events cant be created" do
      before do
        events.second.delete(:env)
      end

      it "should create the valid events" do
        expect {
          create
        }.to change(Event, :count).by(2)
      end

      it "should return an error in place of the failed event" do
        json = create.to_json
        result = Event.last(2)

        json.should == [
          EventDecorator.new(result.first).as_json,
          Api::ErrorDecorator.new(422, ["Env can't be blank"]).as_json,
          EventDecorator.new(result.last).as_json
        ].to_json
      end
    end

    describe "when there are events with metadata" do
      before do
        @data = {
          :user => { :id => '4359', :ua => 'A User Agent' },
          :extra => { :token => "3de4a8d9fe", :runtime => '2.3' },
          :server => { :pid => '2', :host => 'MBP.local', :tid => 'abc123' },
          :backtrace => %w(/lib/gem-name/file:12 /app/models/user:18)
        }

        options.merge!(@data)
      end

      it "should persist the metadata" do
        create

        Event.last(3).each {|event|
          event.user.should == @data[:user].stringify_keys
          event.extra.should == @data[:extra].stringify_keys
          event.server.should == @data[:server].stringify_keys
          event.backtrace.should == @data[:backtrace]
        }
      end
    end
  end
end
