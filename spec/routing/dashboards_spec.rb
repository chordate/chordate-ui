require "spec_helper"

describe :dashboards do
  it "should route GET /dashboard" do
    {:get => "/dashboard"}.should be_routable
  end
end
