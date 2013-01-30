c.v.InviteShowView = (function() {
  return c.v.FormView.extend({
    template: "invites/_show",
    fields: ["name", "password"],
    xhr: "put",

    target: function() {
      return "/applications/" + c.data.application.id + "/invites/" + this.model.id + ".json";
    },

    success: function() {
      c.u.navigate("/applications/" + c.data.application.id);
    }
  });
}())
