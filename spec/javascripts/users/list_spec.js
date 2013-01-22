describe("UserListView", function () {
  var view, request;

  beforeEach(function () {
    c.data.application = new Backbone.Model({id: 123});

    view = new c.v.UserListView();
    request = mostRecentAjaxRequest();
  });

  it("should be a table view", function () {
    expect(view.type).toEqual("TableView");
  });

  it("should have the title", function () {
    expect(view.title).toEqual("Users");
  });

  it("should have the headers", function () {
    expect(view.headers).toEqual(["Name", "Email"])
  });

  it("should have the application events target", function () {
    expect(view.target()).toEqual("/applications/123/users.json");
  });

  it("should have the row", function () {
    expect(view.row).toEqual("_users_list_row")
  });

  it("should not paginate", function () {
    expect(view.paginate).toEqual(false);
  });

  it("should get the target", function () {
    expect(request.method).toEqual("GET");
    expect(request.url).toMatch(/^\/applications\/123\/users/);
  });

  describe("on success", function () {
    beforeEach(function () {
      request.response({
        status: 200,
        responseText: "[]"
      });
    });

    it("should hide the spinner", function () {
      expect(view.$(".spinner")).toHaveClass("hidden");
    });
  });

  var makeUser = function(id) {
    return {
      id: id,
      name: "John Doe " + id,
      email: "john" + id + "@example.com"
    }
  };

  var user = function(which) {
    return view.$("tbody tr:eq(" + which + ")");
  };

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should show the spinner", function () {
      expect(view.$(".spinner")).not.toHaveClass("hidden");
    });

    describe("when the users are returned", function () {
      beforeEach(function () {
        request.response({
          status: 200,
          responseText: JSON.stringify([
            makeUser(44),
            makeUser(21)
          ])
        });
      });

      it("should have the users", function () {
        expect(view.$("tbody tr").length).toEqual(2);
      });

      it("should have the user ids", function () {
        expect(view.$("#user_44")).toExist();
        expect(view.$("#user_21")).toExist();
      });

      it("should have the name", function () {
        expect(user(0)).toHaveText("John Doe 44");
        expect(user(1)).toHaveText("John Doe 21");
      });

      it("should have the email", function () {
        expect(user(0)).toHaveText("john44@example.com");
        expect(user(1)).toHaveText("john21@example.com");
      });
    });
  });
});
