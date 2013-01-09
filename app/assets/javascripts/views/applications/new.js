c.v.ApplicationsNewView = (function() {
  return c.v.FormView.extend({
    target: "/applications",
    template: "_applications_new",
    fields: ["name"],

    success: function() {
      c.u.navigate("/applications");
    }
  })
}());
