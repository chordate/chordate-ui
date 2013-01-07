require "spec_helper"

describe "sessions" do
  it "should route GET /sessions/new" do
    {:get => "/sessions/new"}.should be_routable
  end

  it "should route POST /sessions" do
    {:post => "/sessions"}.should be_routable
  end
end
