c.v.EventsIndexView = (function() {
  return c.v.TableView.extend({
    title: "Events",
    headers: ["Event", "Last Occurrence", "Count", "Severity"],
    row: "_events_row",

    target: function() {
      return "/applications/" + c.data.application.id + "/events.json"
    },

    init: function() {
      var that = this;

      $.get(this.target(), {page: 1}).
        success(function(data) {
          that.collection.reset(data);

          that.$(".spinner").addClass("hidden");
        })
    }
  });
}());
