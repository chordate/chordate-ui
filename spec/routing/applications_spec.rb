require "spec_helper"

describe :applications do
  it "should route GET /applications/new" do
    {:get => "/applications/new"}.should be_routable
  end

  it "should route GET /applications" do
    {:get => "/applications"}.should be_routable
  end

  it "should route GET /applications/123" do
    {:get => "/applications/123"}.should be_routable
  end

  it "should route POST /applications" do
    {:post => "/applications"}.should be_routable
  end
end
