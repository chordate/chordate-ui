c.v.FormView = (function() {
  var template = c.template("form");

  return Backbone.View.extend({
    type: "FormView",
    xhr: "post",

    events: function() {
      var events = (this.formEvents || {});

      return _({
        "submit form": "submit",
        "input input": "update"
      }).extend(events)
    },

    initialize: function() {
      this.errors = [];
      this.model = (this.model || new Backbone.Model());
    },

    render: function() {
      var context = _({errors: this.errors, form: this.template}).extend(this.model.attributes);

      this.$el.html(template(context));

      return this;
    },

    update: function() {
      var that = this,
          attrs = {};

      _(this.fields).each(function(field) {
        attrs[field] = that.$el.find("#" + field).val();
      });

      this.model.set(attrs, {silent: true});
    },

    submit: function(e) {
      var that = this;

      that.stopPropagation(e);

      that.update();

      $.ajax({url: that.target(), data: that.model.attributes, type: that.xhr}).
        success(function(data) {
          that.undelegateEvents();

          that.success && that.success(data);
        }).
        error(function(r) {
          if(r.status === 422) {
            that.errors = _(JSON.parse(r.responseText).errors).clone();

            that.render();
          }

          that.error && that.error(r);
        });
    },

    stopPropagation: function(e) {
      e.stopPropagation();
      e.preventDefault();
    }
  });
}());
