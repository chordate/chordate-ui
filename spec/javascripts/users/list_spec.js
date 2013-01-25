describe("UsersListView", function () {
  var view, request;

  beforeEach(function () {
    c.data.application = new Backbone.Model({id: 123});

    view = new c.v.UsersListView();
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

  it("should take a target type", function () {
    expect(view.target({type: "foo-bar"})).toEqual("/applications/123/foo-bars.json");
  });

  it("should have the row view", function () {
    expect(view.row).toEqual("_users_list_row")
  });

  it("should have the new view", function () {
    expect(view.new).toEqual("_users_list_new")
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
      expect(view.$(".spinner.table")).not.toHaveClass("hidden");
    });

    it("should show the new invite link", function () {
      expect(view.$("#new-invite a")).toExist();
    });

    it("should have the hidden new invite form", function () {
      expect(view.$("#new-invite form")).toExist();
      expect(view.$("#new-invite form")).toHaveClass("hidden");
    });

    it("should have the invite spinner", function () {
      expect(view.$("#new-invite form .spinner.small")).toHaveClass("hidden");
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

  describe("#newInvite", function () {
    var event;

    beforeEach(function () {
      view.render();

      event = jasmine.createEventObj();
      view.invite(event);
    });

    it("should have the new invite form", function () {
      expect(view.$("#new-invite form")).toExist();
    });

    it("should not be hidden", function () {
      expect(view.$("#new-invite form")).not.toHaveClass("hidden");
    });

    it("should have the email field", function () {
      expect(view.$("input[type='text'].email")).toExist();
    });

    it("should show the submit button", function () {
      expect(view.$("input[type='submit']")).toExist();
    });
  });

  describe("#submitNewUser", function () {
    var event, request, email;

    beforeEach(function () {
      view.render();

      clearAjaxRequests();

      email = "john_10@example.com";
      view.$(".email").val(email);

      event = jasmine.createEventObj();
      view.submitInvite(event);

      request = mostRecentAjaxRequest();
    });

    it("should stop the default form submission", function () {
      expect(event.stopPropagation).toHaveBeenCalled();
      expect(event.preventDefault).toHaveBeenCalled();
    });

    it("should hide the submit button", function () {
      expect(view.$("input[type='submit']")).toHaveClass("hidden");
    });

    it("should show the spinner", function () {
      expect(view.$("#new-invite form .spinner.small")).not.toHaveClass("hidden");
    });

    it("should have the email", function () {
      expect(view.$(".email").val()).toEqual(email);
    });

    it("should not show the success message", function () {
      expect(view.$(".success")).toHaveClass("hidden");
    });

    it("should POST to /applications/123/invites.json", function () {
      expect(request.method).toEqual("POST");
      expect(request.url).toMatch(/^\/applications\/123\/invites\.json/);
    });

    it("should send the email address", function () {
      expect(request.params).toMatch(/email\=john_10%40example\.com/);
    });

    describe("on success", function () {
      beforeEach(function () {
        request.response({
          status: 200,
          responseText: "{}"
        });
      });

      it("should hide the spinner", function () {
        expect(view.$("#new-invite form .spinner.small")).toHaveClass("hidden");
      });

      it("should show submit button", function () {
        expect(view.$("input[type='submit']")).not.toHaveClass("hidden");
      });

      it("should clear the email", function () {
        expect(view.$(".email").val()).toEqual("");
      });

      it("should show the success message", function () {
        expect(view.$(".success")).not.toHaveClass("hidden");
        expect(view.$(".success")).toHaveText(I18n.t("invites.new.success"));
      });
    });
  });
});
