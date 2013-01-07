describe("UsersNewView", function () {
  var view;

  beforeEach(function () {
    view = new c.v.UsersNewView();
  });

  it("should have errors", function () {
    expect(view.errors).toEqual([]);
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

    it("shouldn't have errors", function () {
      expect(view.$el.find(".errors")).toExist();
      expect(view.$el.find(".error").length).toEqual(0);
    });
  });

  describe("#submit", function () {
    var event, request;

    beforeEach(function () {
      view.render();

      spyOn(c.u, "navigate");
      event = jasmine.createEventObj();

      view.$el.find("#name").val("John Doe");
      view.$el.find("#email").val("john@example.com");
      view.$el.find("#password").val("John's Password").trigger("input");

      view.submit(event);

      request = mostRecentAjaxRequest();
    });

    it("should stop the default form submission", function () {
      expect(event.preventDefault).toHaveBeenCalled();
      expect(event.stopPropagation).toHaveBeenCalled();
    });

    it("should clear the errors", function () {
      expect(view.errors).toEqual([]);
    });

    it("should POST to /users", function () {
      expect(request.method).toEqual("POST");
      expect(request.url).toMatch(/^\/users/);
    });

    it("should send the name, email and password", function () {
      expect(request.params).toMatch(/name\=John\+Doe/);
      expect(request.params).toMatch(/email\=john%40example\.com/);
      expect(request.params).toMatch(/password\=John's\+Password/);
    });

    describe("on success", function () {
      beforeEach(function () {
        spyOn(view, "undelegateEvents");

        request.response({
          status: 201,
          responseText: "{}"
        });
      });

      it("should remove event listeners", function () {
        expect(view.undelegateEvents).toHaveBeenCalled();
      });

      it("should navigate to /dashboard", function () {
        expect(c.u.navigate).toHaveBeenCalledWith("/dashboard");
      });
    });

    describe("on error", function () {
      beforeEach(function () {
        request.response({
          status: 422,
          responseText: JSON.stringify({errors: ["Some Error", "Other Error"]})
        });
      });

      it("should not navigate to /dashboard", function () {
        expect(c.u.navigate).not.toHaveBeenCalled();
      });

      it("should store the errors", function () {
        expect(view.errors).toEqual(["Some Error", "Other Error"]);
      });

      it("should have the errors", function () {
        expect(view.$el.find(".error").length).toEqual(2);
      });

      it("should show the errors", function () {
        expect(view.$el.find(".error:first")).toHaveText("Some Error");
        expect(view.$el.find(".error:last")).toHaveText("Other Error");
      });

      it("should retain the name", function () {
        expect(view.$el.find("#name").val()).toEqual("John Doe")
      });
      it("should retain the email", function () {
        expect(view.$el.find("#email").val()).toEqual("john@example.com")
      });

      it("should retain the password", function () {
        expect(view.$el.find("#password").val()).toEqual("John's Password")
      });
    });
  });
});
