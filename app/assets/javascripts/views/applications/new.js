c.v.ApplicationsNewView = (function() {
  return c.v.FormView.extend({
    template: "_applications_new",
    fields: ["name"],

    target: function() {
      return "/applications"
    },

    success: function() {
      c.u.navigate("/applications");
    }
  })
}());
