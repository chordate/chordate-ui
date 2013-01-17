c.v.EventsFilterKlassView = (function() {
  return c.v.TableView.extend({
    title: "Error Class",
    headers: [""],
    paginate: false,
    row: "_events_filter_klass_row",

    target: function() {
      return "/applications/" + c.data.application.id + "/filters.json?model=event&type=klass"
    },

    tableEvents: {
      "click .filter a": "filter"
    },

    init: function() {
      var that = this;

      $.get(that.target()).
        success(function(data) {
          that.collection.reset(data);

          that.hideSpinner();
        }).
        error(function() {
          that.hideSpinner();
        });
    },

    afterRender: function() {
      this.showSpinner();
    },

    filter: function(e) {
      var $tr = $(e.currentTarget),
          events = this.options.eventsCollection;

      events.filters = { klass: $tr.data("klass") };

      events.trigger("filter");
    }
  });
}());
