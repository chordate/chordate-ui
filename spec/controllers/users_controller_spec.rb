require "spec_helper"

describe UsersController do
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

  describe "#index" do
    let(:user) { User.first }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:application) { Application.first }

    before do
      sign_in user
    end

    describe ".json" do
      let(:options) { {} }

      describe "by application" do
        def make_request
          xhr :get, :index, {:format => "json", :application_id => application.id}.merge(options)
        end

        before do
          application.users << other_user
        end

        it "should be successful" do
          make_request

          response.should be_success
        end

        it "should return many users" do
          make_request

          response.body.should == UserDecorator.many([user, other_user]).to_json
        end

        describe "when there are users for other applications" do
          let(:ordered_user) { FactoryGirl.create(:user) }

          before do
            @user = FactoryGirl.create(:user)
            @application = FactoryGirl.create(:application, :user => @user)

            @application.users << ordered_user
            @application.users << user
          end

          it "should scope the users" do
            make_request

            json = JSON.parse(response.body).collect {|i| i['id']}

            json.should include(user.id)
            json.should include(other_user.id)
            json.should_not include(ordered_user.id)
            json.should_not include(@user.id)
          end

          describe "when requesting that application" do
            before do
              options[:application_id] = @application.id
            end

            it "should return many users" do
              make_request

              response.body.should == UserDecorator.many([@user, ordered_user, user]).to_json
            end
          end
        end
      end
    end
  end

  describe "#create" do
    let(:name) { "John Doe" }
    let(:email) { "john-doe@example.com" }
    let(:password) { "john's password" }

    describe ".json" do
      def make_request
        xhr :post, :create, :name => name, :email => email, :password => password, :format => "json"
      end

      it "should be a 201" do
        make_request

        response.code.should == "201"
      end

      it "should add a user" do
        expect {
          make_request
        }.to change(User, :count).by(1)
      end

      it "should have the attributes" do
        make_request

        user = User.last
        user.name.should == name
        user.email.should == email
        user.password.should_not == password
      end

      it "should store a valid password" do
        make_request

        user = User.last
        user.should be_valid_password(password)
      end

      it "should return the user" do
        make_request

        response.body.should == UserDecorator.new(User.last).to_json
      end

      it "should set the cookies" do
        controller.should_receive(:set_cookie).and_return(true)

        make_request
      end

      describe "when the email has been taken" do
        before do
          @user = User.first.tap {|u| u.update_column(:email, email)}
        end

        it "should not create a user" do
          expect {
            make_request
          }.not_to change(User, :count)
        end

        it "should be a 422" do
          make_request

          response.code.should == "422"
        end

        it "should render the error" do
          make_request

          JSON.parse(response.body)['errors'].should include("Email has already been taken")
        end

        it "should not set the cookies" do
          controller.should_not_receive(:set_cookie)

          make_request
        end
      end
    end
  end
end
