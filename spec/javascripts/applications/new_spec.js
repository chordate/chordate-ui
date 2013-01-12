describe("ApplicationsNewView", function () {
  var view;

  beforeEach(function () {
    view = new c.v.ApplicationsNewView();
  });

  it("should be a form view", function () {
    expect(view.type).toEqual("FormView");
  });

  it("should have a target", function () {
    expect(view.target()).toEqual("/applications");
  });

  it("should have fields", function () {
    expect(view.fields).toEqual(["name"]);
  });

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should render the name field", function () {
      expect(view.$el.find("label[for='name']")).toExist();
      expect(view.$el.find("input[type='text']#name")).toExist();
    });

    it("should have a submit button", function () {
      expect(view.$el.find("input[type='submit']")).toExist();
    });
  });

  describe("#success", function () {
    beforeEach(function () {
      view.success();
    });

    it("should navigate to /applications", function () {
      expect(c.u.navigate).toHaveBeenCalledWith("/applications");
    });
  });
});
