require "spec_helper"

describe ApplicationsController do
  let(:user) { User.first }

  describe "#new" do
    describe ".html" do
      def make_request
        get :new, :format => "html"
      end

      before do
        sign_in user
      end

      it "should be successful" do
        make_request

        response.should be_success
      end
    end
  end

  describe "#index" do
    describe ".html" do
      def make_request
        get :index, :format => "html"
      end

      before do
        sign_in user
      end

      it "should be successful" do
        make_request

        response.should be_success
      end
    end
  end

  describe "#show" do
    let(:application) { Application.first }

    describe ".html" do
      def make_request
        get :show, :id => application.id, :format => "html"
      end

      before do
        sign_in user
      end

      it "should be successful" do
        make_request

        response.should be_success
      end
    end
  end

  describe "#create" do
    describe ".json" do
      def make_request
        xhr :post, :create, :name => "Application Name 1", :format => "json"
      end

      before do
        sign_in user
      end

      it "should be a 201" do
        make_request

        response.code.should == "201"
      end

      it "should create an application" do
        expect {
          make_request
        }.to change(Application, :count).by(1)
      end

      it "should have the name" do
        make_request

        Application.last.name.should == "Application Name 1"
      end

      it "should generate an api token" do
        make_request

        Application.last.token.should_not be_blank
      end

      it "should return the application" do
        make_request

        response.body.should == ApplicationDecorator.new(Application.last).to_json
      end

      describe "when not given a valid name" do
        def make_request
          xhr :post, :create, :name => "", :format => "json"
        end

        it "should be a 422" do
          make_request

          response.code.should == "422"
        end

        it "should not create an application" do
          expect {
            make_request
          }.not_to change(Application, :count)
        end

        it "should return the errors" do
          make_request

          JSON.parse(response.body)['errors'].first.should match(/Name can\'t be blank/)
        end
      end
    end
  end
end
