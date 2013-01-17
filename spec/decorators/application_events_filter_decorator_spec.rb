require "spec_helper"

describe ApplicationEventsFilterDecorator do
  let(:application) { Application.first }
  let(:allowed) { [] }
  let(:options) { {} }

  subject { ApplicationEventsFilterDecorator.new(application, options) }

  it_behaves_like "a decorator"

  describe "#valid?" do
    it { should_not be_valid }

    describe "when given the model option" do
      before do
        options[:model] = "value"
      end

      it { should_not be_valid }

      describe "when given the event model" do
        before do
          options[:model] = "event"
        end

        it { should_not be_valid }

        describe "when given the klass type" do
          before do
            options[:type] = "klass"
          end

          it { should be_valid }
        end
      end

      describe "when given the klass type" do
        before do
          options[:type] = "klass"
        end

        it { should_not be_valid }
      end
    end
  end

  describe "#as_json" do
    before do
      @events = [
        FactoryGirl.create(:event, :klass => "FirstError", :application => application),
        FactoryGirl.create(:event, :klass => "FirstError", :application => application),
        FactoryGirl.create(:event, :klass => "LastError", :application => application)
      ]
    end

    it "should be an empty set" do
      subject.to_json.should == [].to_json
    end

    describe "when given valid options" do
      describe "when given the 'event' model and the 'klass' type" do
        before do
          options.merge!(
            :model => "event",
            :type => "klass"
          )
        end

        it { should be_valid }

        it "should return the klasses and counts" do
          JSON.parse(subject.to_json).should == [
            {
              "name" => "FirstError",
              "count" => 2
            },
            {
              "name" => "LastError",
              "count" => 1
            }
          ]
        end
      end
    end
  end
end
