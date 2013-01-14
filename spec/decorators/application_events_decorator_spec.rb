require "spec_helper"

describe ApplicationEventsDecorator do
  let(:application) { Application.first }
  let(:allowed) { [] }
  let(:options) { {} }

  subject { ApplicationEventsDecorator.new(application, options) }

  it_behaves_like "a decorator"

  describe "#as_json" do
    before do
      @events = [
        FactoryGirl.create(:event, :klass => "FirstError", :application => application),
        FactoryGirl.create(:event, :klass => "LastError", :application => application)
      ]
    end

    it "should return the events" do
      subject.to_json.should == @events.reverse.collect {|event| EventDecorator.new(event) }.to_json
    end

    describe "when there are events with the same class" do
      before do
        @events.unshift(
          FactoryGirl.create(:event, :klass => "FirstError", :generated_at => 1.minute.from_now, :application => application)
        )
      end

      it "should return the most recent events" do
        json = JSON.parse(subject.to_json)

        json.should include(JSON.parse(EventDecorator.new(@events.first).to_json))
        json.should include(JSON.parse(EventDecorator.new(@events.last).to_json))
      end
    end

    describe "when given an environment" do
      let(:environment) { "the_env" }

      before do
        options[:env] = environment

        @other_event = FactoryGirl.create(:event, :env => environment, :application => application)
      end

      it "should only return events from that environment" do
        subject.to_json.should == [EventDecorator.new(@other_event)].to_json
      end
    end

    describe "when given a class" do
      let(:klass) { "UserClass" }

      before do
        options[:klass] = klass.tap {|k| @events.last.update_column(:klass, k) }
      end

      it "should filter to matching events" do
        subject.to_json.should == [EventDecorator.new(@events.last)].to_json
      end
    end

    describe "sorting" do
      before do
        @events.push(
          FactoryGirl.create(:event, :klass => "FirstError", :generated_at => 1.minute.from_now, :application => application)
        )
      end

      it "should sort the results by generation time" do
        subject.to_json.should == @events.last(2).reverse.collect {|event| EventDecorator.new(event) }.to_json
      end
    end

    describe "when filtering by model type" do
      let(:model) { "UserModel" }

      before do
        options[:model_type] = model.tap {|t| @events.first.update_column(:model_type, t) }
      end

      it "should filter to matching events" do
        subject.to_json.should == @events.first(1).collect {|event| EventDecorator.new(event) }.to_json
      end

      describe "when filtering by model id" do
        before do
          @events.each {|e| e.update_column(:model_type, model) }

          options[:model_id] = "1123".tap {|i| @events.last.update_column(:model_id, i) }
        end

        it "should filter to matching events" do
          subject.to_json.should == @events.last(1).collect {|event| EventDecorator.new(event) }.to_json
        end
      end
    end
  end
end
