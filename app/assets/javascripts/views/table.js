c.v.TableView = (function() {
  var template = c.template("table");

  return Backbone.View.extend({
    type: "TableView",
    paginate: true,

    events: function() {
      var events = (this.tableEvents || {});

      return _({
        'click .page': 'paging'
      }).extend(events)
    },

    initialize: function() {
      _.bindAll(this, 'render');

      this.page = 1;
      this.collection = new Backbone.Collection([]);

      this.collection.on('reset', this.render);

      this.init && this.init();
    },

    render: function() {
      var attrs = _(this).pick("paginate", "title", "headers", "page", "row", "new"),
          context = _({
            collection: this.collection.models,
            next: attrs.page + 1
          }).extend(attrs);

      this.$el.html(template(context));

      return this;
    },

    paging: function(e) {
      var that = this,
          filters = (that.collection.filters || {}),
          $page = $(e.currentTarget);

      that.page = parseInt($page.data("page"), 10);

      var options = _({page: that.page}).extend(filters);

      that.showSpinner();

      $.get(that.target(), options).
        success(function(data) {
          that.success && that.success(data);

          that.collection.reset(data);
          that.hideSpinner();
        }).
        error(function() {
          that.error && that.error();

          that.hideSpinner();
        });
    },

    stopPropagation: function(e) {
      e.stopPropagation();
      e.preventDefault();
    },

    showSpinner: function() {
      this.$(".spinner").removeClass("hidden");
    },

    hideSpinner: function() {
      this.$(".spinner").addClass("hidden");
    }
  })
}());
