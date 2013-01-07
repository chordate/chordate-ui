require "spec_helper"

describe SessionsController do
  describe "#new" do
    describe ".html" do
      def make_request
        get :new, :format => "html"
      end

      it "should be success" do
        make_request

        response.should be_success
      end
    end
  end

  describe "#create" do
    let(:password) { "password" }
    let(:user_password) { password }

    describe ".html" do
      let(:user) { FactoryGirl.create(:user, :password => user_password) }

      def make_request
       xhr :post, :create, :email => user.email, :password => password, :format => "json"
      end

      it "should be a 201" do
        make_request

        response.code.should == "201"
      end

      it "should create a new session" do
        session = mock(Session, :login => true, :token => true)
        Session.should_receive(:new).with('email' => user.email, 'password' => password).and_return(session)

        make_request
      end

      it "should set the cookies" do
        controller.should_receive(:set_cookie).and_return(true)

        make_request
      end

      describe "when given the wrong password" do
        let!(:user_password) { "wrong password" }

        it "should be a 422" do
          make_request

          response.code.should == "422"
        end

        it "should render the error" do
          make_request

          JSON.parse(response.body)['errors'].should include(I18n.t("sessions.create.error"))
        end

        it "should not set the cookies" do
          controller.should_not_receive(:set_cookie)

          make_request
        end
      end
    end
  end
end
