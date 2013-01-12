c.v.SessionsNewView = (function() {
  return c.v.FormView.extend({
    template: "_sessions_new",
    fields: ["email", "password"],

    target: function() {
      return "/sessions";
    },

    success: function() {
      c.u.navigate("/dashboard");
    }
  });
}());
