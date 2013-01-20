describe("EventsFilterModelTypeView", function () {
  var view, request;

  var makeFilter = function(id) {
    return {
      name: "UserClass " + id,
      count: (id * 100)
    }
  };

  var respondToFilters = function() {
    request.response({
      status: 200,
      responseText: JSON.stringify([
        makeFilter(44),
        makeFilter(21)
      ])
    });
  };

  beforeEach(function () {
    c.data.application = new Backbone.Model({id: 123});

    view = new c.v.EventsFilterModelTypeView();

    request = mostRecentAjaxRequest();
  });

  it("should be a table view", function () {
    expect(view.type).toEqual("TableView");
  });

  it("should not paginate", function () {
    expect(view.paginate).toEqual(false);
  });

  it("should have the title", function () {
    expect(view.title).toEqual("Offending Model");
  });

  it("should have the headers", function () {
    expect(view.headers).toEqual([""])
  });

  it("should have the application events target", function () {
    expect(view.target()).toEqual("/applications/123/filters.json?model=event&type=model_type");
  });

  it("should have the row", function () {
    expect(view.row).toEqual("_events_filter_model_type_row")
  });

  it("should get the target", function () {
    expect(request.method).toEqual("GET");
    expect(request.url).toMatch(/^\/applications\/123\/filters\.json\?model=event&type=model_type/);
  });

  describe("on success", function () {
    beforeEach(function () {
      respondToFilters();
    });

    it("should hide the spinner", function () {
      expect(view.$(".spinner")).toHaveClass("hidden");
    });
  });

  describe("#render", function () {
    beforeEach(function () {
      view.render();
    });

    it("should show the spinner", function () {
      expect(view.$(".spinner")).not.toHaveClass("hidden");
    });

    describe("when the filters are returned", function () {
      var error = function(which) {
        return view.$("tbody tr:eq(" + which + ")");
      };

      beforeEach(function () {
        respondToFilters();
      });

      it("should have the filters", function () {
        expect(view.$("tbody tr").length).toEqual(2);
      });

      it("should hide the spinner", function () {
        expect(view.$(".spinner")).toHaveClass("hidden");
      });

      it("should have the filter names", function () {
        expect(error(0)).toHaveText("UserClass 44");
        expect(error(1)).toHaveText("UserClass 21");
      });

      it("should have the names in data", function () {
        expect(error(0).data("model_type")).toEqual("UserClass 44");
        expect(error(1).data("model_type")).toEqual("UserClass 21");
      });

      it("should have the error counts", function () {
        expect(error(0).find(".count")).toHaveText("4400");
        expect(error(1).find(".count")).toHaveText("2100");
      });
    });
  });

  describe("#filter", function () {
    var event, events, filter;

    beforeEach(function () {
      view.render();
      respondToFilters();

      event = jasmine.createEventObj();
      event.currentTarget = view.$("tbody tr:first");

      view.options.eventsCollection = events = new Backbone.Collection([]);

      filter = jasmine.createSpy("filter");
      events.on("filter", filter);

      view.filter(event);
    });

    it("should set the filter on the collection", function () {
      expect(events.filters).toEqual({model_type: "UserClass 44"})
    });

    it("should trigger the filter event on the events", function () {
      expect(filter).toHaveBeenCalled();
    });
  });
});
