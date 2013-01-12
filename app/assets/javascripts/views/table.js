c.v.TableView = (function() {
  var template = c.template("table");

  return Backbone.View.extend({
    type: "TableView",

    events: function() {
      var events = (this.formEvents || {});

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
      var attrs = _(this).pick("title", "headers", "page", "row"),
          context = _({
            collection: this.collection.models,
            next: attrs.page + 1
          }).extend(attrs);

      this.$el.html(template(context));
      this.$(".spinner").addClass("hidden");

      return this;
    },

    paging: function(e) {
      var that = this,
          $page = $(e.currentTarget);

      that.page = parseInt($page.data("page"), 10);

      that.$(".spinner").removeClass("hidden");

      $.get(that.target(), {page: that.page}).
        success(function(data) {
          that.success && that.success(data);

          that.collection.reset(data);
          that.$(".spinner").addClass("hidden");
        }).
        error(function() {
          that.error && that.error();

          that.$(".spinner").addClass("hidden");
        });
    }
  })
}());
