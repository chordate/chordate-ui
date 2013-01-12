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
      let(:defaults) { {} }

      def make_request
        xhr :get, :index, {:application_id => application.id, :format => "json"}.merge(defaults)
      end

      it "should be a 200" do
        make_request

        response.code.should == "200"
      end

      describe "when there are events" do
        before do
          @events = FactoryGirl.create_list(:event, 2, :application => application)
        end

        it "should return the events" do
          make_request

          response.body.should == [
            EventDecorator.new(@events.last),
            EventDecorator.new(@events.first)
          ].to_json
        end

        describe "ordering" do
          before do
            @events.first.update_column(:generated_at, 2.minutes.ago)
            @events.last.update_column(:generated_at, 1.minute.ago)
          end

          it "should order the events based on generation time" do
            make_request

            response.body.should == [
                EventDecorator.new(@events.last),
                EventDecorator.new(@events.first)
            ].to_json
          end
        end


        describe "when there are events from other applications" do
          before do
            @events.last.update_attributes(:application => FactoryGirl.create(:application))
          end

          it "should return the events" do
            make_request

            response.body.should == [
                EventDecorator.new(@events.first)
            ].to_json
          end
        end

        describe "when events have the same klass" do
          before do
            Timecop.freeze(DateTime.now) do
              @events.first.update_attributes(:klass => "AnError", :generated_at => 2.minutes.ago)
              @events.last.update_attributes(:klass => "AnError", :generated_at => 1.minute.ago)

              @other_event = FactoryGirl.create(:event, :application => application, :generated_at => 1.minute.ago)
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
end
