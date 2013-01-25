require "spec_helper"

describe :invites do
  it "should route POST /applications/:application_id/invites" do
    {:post => "/applications/123/invites"}.should be_routable
  end

  it "should route PUT /applications/:application_id/invites/:id" do
    {:put => "/applications/123/invites/12"}.should be_routable
  end

  it "should route GET /applications/:application_id/invites/:id" do
    {:get => "/applications/123/invites/3"}.should be_routable
  end
end
