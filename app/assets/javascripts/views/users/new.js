c.v.UsersNewView = (function(){
  var template = c.template("users/new");

  return Backbone.View.extend({
    events: {
      "submit form": "submit",
      "input input": "update"
    },

    initialize: function() {
      this.errors = [];
      this.model = new Backbone.Model();
    },

    render: function() {
      var context = _({errors: this.errors}).extend(this.model.attributes);

      this.$el.html(template(context));

      return this;
    },

    update: function() {
      this.model.set({
        name: this.$el.find("#name").val(),
        email: this.$el.find("#email").val(),
        password: this.$el.find("#password").val()
      }, {silent: true});
    },

    submit: function(e) {
      var that = this;

      e.stopPropagation();
      e.preventDefault();

      $.post("/users", that.model.attributes).
        success(function() {
          that.undelegateEvents();

          c.u.navigate("/dashboard");
        }).
        error(function(r) {
          if(r.status === 422) {
            that.errors = _(JSON.parse(r.responseText).errors).clone();

            that.render();
          }
        });
    }
  });
}());
