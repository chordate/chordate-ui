c.v.UsersNewView = (function(){
  return c.v.FormView.extend({
    template: "users/_new",
    fields: ["name", "email", "password"],

    target: function() {
      return "/users";
    },

    success: function() {
      c.u.navigate("/dashboard");
    }
  });
}());
