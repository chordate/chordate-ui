require "spec_helper"

describe FiltersController do
  let(:user) { User.first }
  let(:application) { Application.first }

  describe "#index" do
    before do
      sign_in user
    end

    describe ".json" do
      let(:options) { {} }

      def make_request
        xhr :get, :index, { :application_id => application.id }.merge(options)
      end

      it "should be a 422" do
        make_request

        response.code.should == "422"
      end

      describe "when given the event model" do
        before do
          options[:model] = "event"
        end

        describe "when given the klass type" do
          before do
            options[:type] = "klass"
          end

          it "should be successful" do
            make_request

            response.should be_success
          end

          describe "when there are events" do
            before do
              FactoryGirl.create_list(:event, 2, :application => application)
            end

            it "should have both event error classes" do
              make_request

              JSON.parse(response.body).should have(2).items
            end

            it "should return the filters" do
              make_request

              response.body.should == ApplicationEventsFilterDecorator.new(application, options).to_json
            end
          end
        end
      end
    end
  end
end
