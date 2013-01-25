require "spec_helper"

describe :events do
  it "should route GET /applications/:application_id/events" do
    {:get => "/applications/123/events"}.should be_routable
  end
end
