c.v.UsersNewView = (function(){
  return c.v.FormView.extend({
    template: "_users_new",
    fields: ["name", "email", "password"],

    target: function() {
      return "/users";
    },

    success: function() {
      c.u.navigate("/dashboard");
    }
  });
}());
