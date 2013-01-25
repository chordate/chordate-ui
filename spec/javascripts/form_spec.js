describe("FormView", function () {
  var view;

  beforeEach(function () {
    view = new c.v.FormView();
    view.target = function() { return "/the_endpoint_to_submit_to" };
    view.fields = ["email"]
  });

  it("should be a form view", function () {
    expect(view.type).toEqual("FormView");
  });

  it("should POST", function () {
    expect(view.xhr).toEqual("post");
  });

  it("should have errors", function () {
    expect(view.errors).toEqual([]);
  });

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("shouldn't have errors", function () {
      expect(view.$el.find(".errors")).toExist();
      expect(view.$el.find(".error").length).toEqual(0);
    });
  });

  describe("#submit", function () {
    var event, request, success, error;

    beforeEach(function () {
      success = error = false;

      view.success = function() {
        success = true;
      };

      view.error = function() {
        error = true;
      };

      view.render();
      view.$el.find("div").append("<input type='text' id='email'/>");
      view.$el.find("#email").val("john@example.com");

      event = jasmine.createEventObj();
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

    it("should POST to #endpoint", function () {
      expect(request.method).toEqual("POST");
      expect(request.url).toMatch(/^\/the_endpoint_to_submit_to/);
    });

    it("should send the fields", function () {
      expect(request.params).toMatch(/email\=john%40example\.com/);
    });

    describe("when updating", function () {
      beforeEach(function () {
        clearAjaxRequests();

        view.xhr = "put";

        view.submit(event);
        request = mostRecentAjaxRequest();
      });

      it("should PUT to #endpoint", function () {
        expect(request.method).toEqual("PUT");
        expect(request.url).toMatch(/^\/the_endpoint_to_submit_to/);
      });

      it("should send the fields", function () {
        expect(request.params).toMatch(/email\=john%40example\.com/);
      });
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

      it("shouldn't have errors", function () {
        expect(view.$el.find(".errors")).toExist();
        expect(view.$el.find(".error").length).toEqual(0);
      });

      it("should call the success function", function () {
        expect(success).toEqual(true);
      });

      it("should not call the error function", function () {
        expect(error).toEqual(false);
      });
    });

    describe("on error", function () {
      beforeEach(function () {
        request.response({
          status: 422,
          responseText: JSON.stringify({errors: ["Some Error", "Other Error"]})
        });
      });

      it("should call the error function", function () {
        expect(error).toEqual(true);
      });

      it("should not call the success function", function () {
        expect(success).toEqual(false);
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
    });
  });
});
