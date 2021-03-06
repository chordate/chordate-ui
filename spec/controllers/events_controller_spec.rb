require "spec_helper"

describe EventsController do
  let(:user) { User.first }
  let(:application) { Application.first }

  describe "#index" do
    before do
      sign_in user
    end

    describe ".html" do
      def make_request
        get :index, :application_id => application.id, :format => "html"
      end

      it "should be successful" do
        make_request

        response.should be_success
      end
    end

    describe ".json" do
      let(:options) { {} }

      def make_request
        xhr :get, :index, {:application_id => application.id, :format => "json"}.merge(options)
      end

      it "should be a 200" do
        make_request

        response.code.should == "200"
      end

      describe "when there are events" do
        before do
          @events = [
            FactoryGirl.create(:event, :generated_at => 2.minutes.ago, :application => application),
            FactoryGirl.create(:event, :generated_at => 1.minute.ago, :application => application),
          ]
        end

        it "should return the events in order by generation time" do
          make_request

          response.body.should == [
            EventDecorator.new(@events.last),
            EventDecorator.new(@events.first)
          ].to_json
        end

        describe "when there are events from other applications" do
          before do
            @events.push(FactoryGirl.create(:event, :application => FactoryGirl.create(:application)))
          end

          it "should return the events" do
            make_request

            response.body.should == [
                EventDecorator.new(@events.second),
                EventDecorator.new(@events.first)
            ].to_json
          end
        end

        describe "when filtering by class" do
          before do
            options[:klass] = "User".tap {|k| @events.last.update_column(:klass, k) }
          end

          it "should return the matching events" do
            make_request

            response.body.should == [EventDecorator.new(@events.last)].to_json
          end
        end

        describe "when filtering by model type" do
          before do
            options[:model_type] = "UserClass".tap {|t| @events.last.update_column(:model_type, t) }
          end

          it "should return the matching events" do
            make_request

            response.body.should == [EventDecorator.new(@events.last)].to_json
          end
        end

        describe "when filtering by model id" do
          before do
            options[:model_id] = "1234".tap {|i| @events.first.update_column(:model_id, i) }
          end

          it "should return the matching events" do
            make_request

            response.body.should == [EventDecorator.new(@events.first)].to_json
          end
        end
      end

      describe "when events have the same klass" do
        before do
          Timecop.freeze(DateTime.now) do
            @events = [
              FactoryGirl.create(:event, :klass => "AnError", :generated_at => 2.minutes.ago, :application => application),
              FactoryGirl.create(:event, :klass => "AnError", :generated_at => 1.minute.ago, :application => application),
            ]

            @other_event = FactoryGirl.create(:event, :application => application, :generated_at => 1.1.minutes.ago)
          end
        end

        it "should return the most recent events" do
          make_request

          response.body.should == [
            EventDecorator.new(@events.last),
            EventDecorator.new(@other_event)
          ].to_json
        end
      end
    end
  end
end
