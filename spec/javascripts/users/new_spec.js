describe("UsersNewView", function () {
  var view;

  beforeEach(function () {
    view = new c.v.UsersNewView();
  });

  it("should be a form view", function () {
    expect(view.type).toEqual("FormView");
  });

  it("should have a target", function () {
    expect(view.target).toEqual("/users");
  });

  it("should have fields", function () {
    expect(view.fields).toEqual(["name", "email", "password"]);
  });

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should render the name field", function () {
      expect(view.$el.find("label[for='name']")).toExist();
      expect(view.$el.find("input[type='text']#name")).toExist();
    });

    it("should render the email field", function () {
      expect(view.$el.find("label[for='email']")).toExist();
      expect(view.$el.find("input[type='text']#email")).toExist();
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

    it("should navigate to /dashboard", function () {
      expect(c.u.navigate).toHaveBeenCalledWith("/dashboard");
    });
  });
});
