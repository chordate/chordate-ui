c.v.SessionsNewView = (function() {
  return c.v.FormView.extend({
    target: "/sessions",
    template: "_sessions_new",
    fields: ["email", "password"],

    success: function() {
      c.u.navigate("/dashboard");
    }
  });
}());
