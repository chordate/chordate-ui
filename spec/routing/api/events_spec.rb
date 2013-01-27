require "spec_helper"

describe "api/events" do
  it "should route POST /v1/applications/:application_id/events" do
    {:post => "/v1/applications/123/events"}.should be_routable
  end

  it "should route GET /v1/applications/:application_id/events.json" do
    {:get => "/v1/applications/123/events.json"}.should route_to(:controller => "events", :action => "index", :application_id => "123", :format => "json")
  end

  it "should route POST /v1/applications/:application_id/events/:id" do
    {:put => "/v1/applications/123/events/12"}.should be_routable
  end
end
