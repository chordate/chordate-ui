require "spec_helper"

describe DashboardsController do
  let(:user) { User.first }

  describe "#index" do
    before do
      sign_in user
    end

    describe ".html" do
      def make_request
        get :index
      end

      it "should be successful" do
        make_request

        response.should be_success
      end

      describe "when the user is not logged in" do
        # testing the application controller implicitly

        before do
          sign_out
        end

        it "should redirect to the login page" do
          make_request

          response.should redirect_to(new_session_path)
        end
      end
    end
  end
end
