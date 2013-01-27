require "spec_helper"

describe "api/events" do
  it "should route POST /v1/applications/:application_id/events" do
    {:post => "/v1/applications/123/events"}.should be_routable
  end
end
