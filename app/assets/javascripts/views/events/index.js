c.v.EventsIndexView = (function() {
  return c.v.TableView.extend({
    title: "Events",
    headers: ["Event", "Last Occurrence", "Count", "Severity"],
    row: "events/_row",

    target: function() {
      return "/applications/" + c.data.application.id + "/events.json"
    },

    init: function() {
      _.bindAll(this, "fetch");

      this.collection.on("filter", this.fetch);

      this.fetch();
    },

    fetch: function() {
      var that = this,
          filters = (that.collection.filters || {}),
          options = _({page: 1}).extend(filters);

      $.get(this.target(), options).
        success(function(data) {
          that.collection.reset(data);

          that.hideSpinner();
        });
    }
  });
}());
