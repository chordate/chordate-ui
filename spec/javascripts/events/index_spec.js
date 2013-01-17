describe("EventsIndexView", function () {
  var view, request;

  beforeEach(function () {
    c.data.application = new Backbone.Model({id: 123});

    view = new c.v.EventsIndexView();
    request = mostRecentAjaxRequest();
  });

  it("should be a table view", function () {
    expect(view.type).toEqual("TableView");
  });

  it("should have the title", function () {
    expect(view.title).toEqual("Events");
  });

  it("should have the headers", function () {
    expect(view.headers).toEqual(["Event", "Last Occurrence", "Count", "Severity"])
  });

  it("should have the application events target", function () {
    expect(view.target()).toEqual("/applications/123/events.json");
  });

  it("should have the row", function () {
    expect(view.row).toEqual("_events_row")
  });

  it("should get the target", function () {
    expect(request.method).toEqual("GET");
    expect(request.url).toMatch(/^\/applications\/123\/events/);
  });

  it("should get the first page", function () {
    expect(request.url).toMatch(/\?page\=1/);
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

  var makeEvent = function(id) {
    return {
      id: id,
      generated_at: "2013-01-01T19:" + id + ":00Z",
      klass: "MyError" + id,
      message: "An Error Message " + id,
      env: "env -- " + id
    }
  };

  var error = function(which) {
    return view.$("tbody tr:eq(" + which + ")");
  };

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should show the spinner", function () {
      expect(view.$(".spinner")).not.toHaveClass("hidden");
    });

    describe("when the events are returned", function () {
      beforeEach(function () {
        request.response({
          status: 200,
          responseText: JSON.stringify([
            makeEvent(44),
            makeEvent(21)
          ])
        });
      });

      it("should have the events", function () {
        expect(view.$("tbody tr").length).toEqual(2);
      });

      it("should have the event ids", function () {
        expect(view.$("#event_44")).toExist();
        expect(view.$("#event_21")).toExist();
      });

      it("should have the error classes", function () {
        expect(error(0)).toHaveText("MyError44");
        expect(error(1)).toHaveText("MyError21");
      });

      it("should have the error messages", function () {
        expect(error(0)).toHaveText("An Error Message 44");
        expect(error(1)).toHaveText("An Error Message 21");
      });

      it("should have the environment", function () {
        expect(error(0)).toHaveText("env -- 44");
        expect(error(1)).toHaveText("env -- 21");
      });

      it("should have the last occurrence", function () {
        expect(error(0)).toHaveText("Jan 1, 2013 @ 11:44:00 AM");
        expect(error(1)).toHaveText("Jan 1, 2013 @ 11:21:00 AM");
      });
    });
  });

  describe("when a filter changes", function () {
    beforeEach(function () {
      mostRecentAjaxRequest().response({ status: 200, responseText: "[]" });

      view.collection.filters = { key: "random-value" }

      view.collection.trigger("filter");

      request = mostRecentAjaxRequest();
      request.response({
        status: 200,
        responseText: JSON.stringify(makeEvent(889))
      });
    });

    it("should have the events", function () {
      expect(view.$("tbody tr").length).toEqual(1);
    });

    it("should have the event ids", function () {
      expect(view.$("#event_889")).toExist();
    });

    it("should have the error classes", function () {
      expect(error(0)).toHaveText("MyError889");
    });

    it("should send the filters", function () {
      expect(request.url).toMatch(/key=random-value/);
    });
  });
});
