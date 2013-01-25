describe("InviteShowView", function () {
  var view, invite;

  beforeEach(function () {
    c.data.application = new Backbone.Model({id: 123});

    invite = new Backbone.Model({id: 12});
    view = new c.v.InviteShowView({model: invite});
  });

  it("should be a form view", function () {
    expect(view.type).toEqual("FormView");
  });

  it("should have a target", function () {
    expect(view.target()).toEqual("/applications/123/invites/12.json");
  });

  it("should have fields", function () {
    expect(view.fields).toEqual(["name", "password"]);
  });

  it("should PUT", function () {
    expect(view.xhr).toEqual("put");
  });

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should render the name field", function () {
      expect(view.$el.find("label[for='name']")).toExist();
      expect(view.$el.find("input[type='text']#name")).toExist();
    });

    it("should render the password field", function () {
      expect(view.$el.find("label[for='password']")).toExist();
      expect(view.$el.find("input[type='password']#password")).toExist();
    });

    it("should have a submit button", function () {
      expect(view.$el.find("input[type='submit']")).toExist();
    });
  });

  describe("#success", function () {
    beforeEach(function () {
      view.success();
    });

    it("should navigate to /applications/123", function () {
      expect(c.u.navigate).toHaveBeenCalledWith("/applications/123");
    });
  });
});
