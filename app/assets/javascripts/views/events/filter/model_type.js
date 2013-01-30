c.v.EventsFilterModelTypeView = (function() {
  return c.v.TableView.extend({
    title: "Offending Model",
    headers: [""],
    paginate: false,
    row: "events/filter/_model_type_row",

    target: function() {
      return "/applications/" + c.data.application.id + "/filters.json?model=event&type=model_type"
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

    filter: function(e) {
      var $tr = $(e.currentTarget),
          events = this.options.eventsCollection;

      events.filters = { model_type: $tr.data("model_type") };

      events.trigger("filter");
    }
  });
}())
