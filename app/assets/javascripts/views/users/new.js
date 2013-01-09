c.v.UsersNewView = (function(){
  return c.v.FormView.extend({
    target: "/users",
    template: "_users_new",
    fields: ["name", "email", "password"],

    success: function() {
      c.u.navigate("/dashboard");
    }
  });
}());
