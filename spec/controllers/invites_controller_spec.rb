require "spec_helper"

describe InvitesController do
  let(:user) { User.first }
  let(:application) { Application.first }

  describe "#show" do
    let(:invite) { FactoryGirl.create(:invite, :user => user, :application => application) }

    describe ".html" do
      let(:options) { {:id => invite.id, :token => invite.token} }

      def make_request
        get :show, {:format => "html", :application_id => application.id}.merge(options)
      end

      it "should be successful" do
        make_request

        response.should be_success
      end

      it "should mark the invite as shown" do
        Timecop.freeze(DateTime.now) do
          make_request

          invite.reload.shown.should == Time.now
        end
      end

      describe "when the invite email is already a user" do
        before do
          @user = FactoryGirl.create(:user, :email => invite.email)
        end

        it "should mark the invite as shown" do
          Timecop.freeze(DateTime.now) do
            make_request

            invite.reload.shown.should == Time.now
          end
        end

        it "should add the user to the application" do
          application.users.should_not include(@user)
          make_request

          application.reload.users.should include(@user)
        end

        it "should redirect to the application" do
          make_request

          response.should redirect_to(application_path(application))
        end
      end

      describe "when the invite is not valid" do
        describe "when the id doesn't match" do
          before do
            options[:id] += 1
          end

          it "should redirect to login" do
            make_request

            response.should redirect_to(new_session_path)
          end
        end

        describe "when the invite token does not match" do
          before do
            options[:token] += "1"
          end

          it "should redirect to login" do
            make_request

            response.should redirect_to(new_session_path)
          end
        end

        describe "when the user cannot grant access on that application" do
          before do
            application.users = []
          end

          it "should redirect to login" do
            make_request

            response.should redirect_to(new_session_path)
          end
        end
      end
    end
  end

  describe "#create" do
    before do
      sign_in user
    end

    describe ".json" do
      def make_request
        xhr :post, :create, :format => "json", :application_id => application.id, :email => "john+invited@example.com"
      end

      it "should be a 201" do
        make_request

        response.code.should == "201"
      end

      it "should add an invite" do
        expect {
          make_request
        }.to change(Invite, :count).by(1)
      end

      it "should store the email" do
        make_request

        Invite.last.email.should == "john+invited@example.com"
      end

      it "should have the application" do
        make_request

        Invite.last.application.should == application
      end

      it "should have the user" do
        make_request

        Invite.last.user.should == user
      end

      it "should generate a long token" do
        make_request

        Invite.last.token.size.should == 48
      end

      it "should return the invite" do
        make_request

        response.body.should == InviteDecorator.new(Invite.last).to_json
      end
    end
  end

  describe "#update" do
    let(:invite) { FactoryGirl.create(:invite, :application => application) }

    describe ".json" do
      let(:options) { { :name => "my name", :password => "my password!", :token => invite.token } }

      def make_request
        xhr :put, :update, {:format => "json", :application_id => application.id, :id => invite.id}.merge(options)
      end

      it "should be successful" do
        make_request

        response.should be_success
      end

      it "should create a user" do
        [application, invite]

        expect {
          make_request
        }.to change(User, :count).by(1)
      end

      it "should be the user for the email" do
        make_request

        User.last.email.should == invite.email
      end

      it "should have the name" do
        make_request

        User.last.name.should == "my name"
      end

      it "should store the valid password" do
        make_request

        User.last.valid_password?("my password!").should == true
      end

      it "should be a member of the application" do
        make_request

        application.users.should include(User.last)
      end

      it "should return the invite" do
        make_request

        response.body.should == InviteDecorator.new(invite).to_json
      end

      describe "when a user exists with that email" do
        before do
          user.update_column(:email, invite.email)
        end

        it "should be a 422" do
          make_request

          response.code.should == "422"
        end
      end
    end
  end
end
