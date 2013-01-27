require "spec_helper"

describe Api::EventsController do
  let(:application) { Application.first }

  describe "#create" do
    def make_event(id)
      {
        :env => "production",
        :klass => "NoMethodError" + id.to_s,
        :message => "undefined method `each' for nil:NilClass",
        :generated_at => id.minutes.ago,
        :source => "UpdateCommentsJob",
        :model_type => "Post",
        :model_id => "223_" + id.to_s,
        :task => "Updating aggregate comment data",
        :user => { :id => "4359", :ua => "A User Agent" },
        :extra => { :token => "3de4a8d9fe", :runtime => '2.3' },
        :server => { :pid => Process.pid, :host => `hostname`.chomp, :tid => Thread.current.object_id },
        :backtrace => %w(/lib/gem-name/file:12 /app/models/user:18)
      }
    end

    describe ".json" do
      let(:options) { { :batch => [make_event(123), make_event(321)] } }

      def make_request
        xhr :post, :create, { :format => "json", :application_id => application.id, :token => application.token }.merge(options)
      end

      it "should be a 201" do
        make_request

        response.code.should == "201"
      end

      it "should create the events" do
        expect {
          make_request
        }.to change(Event, :count).by(2)
      end

      def events(type)
        Event.last(2).collect {|e| e.send(type) }.uniq
      end

      it "should be events of the application" do
        make_request

        events(:application).should == [application]
      end

      it "should have the mandatory fields" do
        make_request

        events(:env).should == %w(production)
        events(:klass).should == %w(NoMethodError123 NoMethodError321)
        events(:message).should == ["undefined method `each' for nil:NilClass"]
        events(:generated_at).collect(&:class).uniq.should == [ActiveSupport::TimeWithZone]
      end

      it "should have the optional fields" do
        make_request

        events(:source).should == %w(UpdateCommentsJob)
        events(:model_type).should == %w(Post)
        events(:model_id).should == %w(223_123 223_321)
        events(:task).should == ["Updating aggregate comment data"]
      end

      it "should store the user, extra, and server information" do
        make_request

        events(:user).should == [{ 'id' => '4359', 'ua' => 'A User Agent' }]
        events(:extra).should == [{ 'token' => '3de4a8d9fe', 'runtime' => '2.3' }]
        events(:server).should == [{ 'pid' => Process.pid.to_s, 'tid' => Thread.current.object_id.to_s, 'host' => `hostname`.chomp }]
      end

      it "should store the backtrace" do
        make_request

        events(:backtrace).should == [%w(/lib/gem-name/file:12 /app/models/user:18)]
      end

      it "should return the events" do
        make_request

        response.body.should == EventDecorator.many(Event.last(2)).to_json
      end

      describe "when mandatory keys are missing" do
        [:env, :klass, :message, :generated_at].each do |key|
          describe "when #{key} is missing" do
            before do
              options[:batch].first[key] = nil
            end

            it "should be a 201" do
              make_request

              response.code.should == "201"
            end

            it "should create the valid events" do
              expect {
                make_request
              }.to change(Event, :count).by(1)
            end

            it "should have the valid event" do
              make_request

              Event.last.klass.should == "NoMethodError321"
            end

            it "should return the events" do
              make_request

              JSON.parse(response.body).last.should == JSON.parse(EventDecorator.new(Event.last).to_json)
            end

            it "should return the errors" do
              make_request

              JSON.parse(response.body).first.should == JSON.parse(Api::ErrorDecorator.new(422, ["#{key.to_s.humanize} can't be blank"]).to_json)
            end
          end
        end
      end
    end
  end

  describe "#update" do
    let(:user) { User.first }
    let(:options) { { :token => user.token } }

    let(:event) { FactoryGirl.create(:event, :application => application) }

    describe ".json" do
      subject { event.reload }

      def make_request
        xhr :put, :update, { :format => "json", :application_id => application.id, :id => event.id }.merge(options)
      end

      it "should be successful" do
        make_request

        response.should be_success
      end

      it "should return the event" do
        make_request

        response.body.should == EventDecorator.new(subject).to_json
      end

      describe "when changing the status" do
        before do
          options[:status] = "resolved"
        end

        it "should update the event" do
          make_request

          should be_resolved
        end

        describe "when the status cannot be updated" do
          before do
            options[:status] = "invalid-status"
          end

          it "should be a 422" do
            make_request

            response.code.should == "422"
          end

          it "should not update the event" do
            make_request

            subject.status.should == "open"
          end

          it "should return an error" do
            make_request

            response.body.should == Api::ErrorDecorator.new(422, ["Status " + I18n.t("events.status.inclusion")]).to_json
          end
        end
      end

      describe "when flagging the event" do
        before do
          options[:flagged] = true
        end

        it "should flag the event" do
          make_request

          should be_flagged
        end

        describe "when the flag is another type of param" do
          before do
            options[:flagged] = "t"
          end

          it "should be successful" do
            make_request

            response.should be_success
          end

          it "should flag the event" do
            make_request

            should be_flagged
          end
        end
      end
    end
  end
end
