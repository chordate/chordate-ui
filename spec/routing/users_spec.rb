require "spec_helper"

describe "users" do
  it "should route GET /users/new" do
    {:get => "/users/new"}.should be_routable
  end

  it "should route POST /users" do
    {:post => "/users"}.should be_routable
  end
end
