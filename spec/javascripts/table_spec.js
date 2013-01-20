describe("TableView", function () {
  var view;

  beforeEach(function () {
    view = new c.v.TableView();
    view.title = "Sample Title";
    view.headers = ["name", "Date", "Details"];
    view.target = function() { return "/sample_target_path" };
  });

  it("should be a table view", function () {
    expect(view.type).toEqual("TableView");
  });

  it("should paginate", function () {
    expect(view.paginate).toEqual(true);
  });

  it("should have a collection", function () {
    expect(view.collection).toBeDefined();
  });

  it("should be page 1", function () {
    expect(view.page).toEqual(1);
  });

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should have the title", function () {
      expect(view.$("h2.title")).toHaveText("Sample Title");
    });

    it("should have the headers", function () {
      var $head = view.$("thead");

      expect($head.find("td").length).toEqual(3);
      expect($head.find("td:eq(0)")).toHaveText("name");
      expect($head.find("td:eq(1)")).toHaveText("Date");
      expect($head.find("td:eq(2)")).toHaveText("Details");
    });

    it("should paginate", function () {
      expect(view.$("#paging .page").length).toEqual(3);
      expect(view.$("#paging .page:eq(0)")).toHaveText("1");
      expect(view.$("#paging .page:eq(1)")).toHaveText("2");
      expect(view.$("#paging .page:eq(2)")).toHaveText("Next");
    });

    it("should be on page 1", function () {
      expect(view.$("#paging .page:first")).toHaveClass("selected");
    });

    it("should have the spinner", function () {
      expect(view.$(".spinner")).toExist();
      expect(view.$(".spinner")).not.toHaveClass("hidden");
    });
  });

  describe("#paging", function () {
    var event, request, success, error;

    beforeEach(function () {
      success = error = false;

      view.render();

      event = jasmine.createEventObj();
      event.currentTarget = "<div data-page='7'/>";

      view.success = function() { success = true; };
      view.error = function() { error = true; };

      view.collection.filters = { key: "random-value" };

      view.paging(event);
      request = mostRecentAjaxRequest();
    });

    it("should be page 7", function () {
      expect(view.page).toEqual(7);
    });

    it("should show the spinner", function () {
      expect(view.$(".spinner")).not.toHaveClass("hidden");
    });

    it("should GET the collection", function () {
      expect(request.method).toEqual("GET");
      expect(request.url).toMatch(/\/sample_target_path/);
    });

    it("should request page 7", function () {
      expect(request.url).toMatch(/page=7/);
    });

    it("should append any filters", function () {
      expect(request.url).toMatch(/key=random-value/);
    });

    it("should not be successful", function () {
      expect(success).toEqual(false);
    });

    it("should not error", function () {
      expect(error).toEqual(false);
    });

    describe("on success", function () {
      var createObj = function(id) {
        return { id: id, name: "Name " + id };
      };

      beforeEach(function () {
        view.title = "Changed Title";

        request.response({
          status: 200,
          responseText: JSON.stringify([
            createObj(4),
            createObj(6)
          ])
        });
      });

      it("should hide the spinner", function () {
        expect(view.$(".spinner")).toHaveClass("hidden");
      });

      it("should reset the collection", function () {
        var names = view.collection.map(function(model) { return [model.id, model.get("name")]; });

        expect(names).toEqual([[4, "Name 4"], [6, "Name 6"]]);
      });

      it("should render the view", function () {
        expect(view.$("h2.title")).toHaveText("Changed Title");
      });

      it("should be successful", function () {
        expect(success).toEqual(true);
      });

      it("should not error", function () {
        expect(error).toEqual(false);
      });
    });

    describe("on error", function () {
      beforeEach(function () {
        request.response({
          status: 500,
          responseText: "{}"
        });
      });

      it("should hide the spinner", function () {
        expect(view.$(".spinner")).toHaveClass("hidden");
      });

      it("should error", function () {
        expect(error).toEqual(true);
      });

      it("should not be successful", function () {
        expect(success).toEqual(false);
      });
    });
  });
});
