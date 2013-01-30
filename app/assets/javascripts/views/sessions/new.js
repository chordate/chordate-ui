c.v.SessionsNewView = (function() {
  return c.v.FormView.extend({
    template: "sessions/_new",
    fields: ["email", "password"],

    target: function() {
      return "/sessions";
    },

    success: function() {
      c.u.navigate("/dashboard");
    }
  });
}());
