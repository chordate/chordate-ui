require "spec_helper"

describe "filters" do
  it "should route GET /applications/:application_id/filters" do
    {:get => "/applications/123/filters"}.should be_routable
  end
end
