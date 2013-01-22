c.v.UserListView = (function() {
  return c.v.TableView.extend({
    title: "Users",
    headers: ["Name", "Email"],
    row: "_users_list_row",
    paginate: false,

    target: function() {
      return "/applications/" + c.data.application.id + "/users.json";
    },

    init: function() {
      var that = this;

      $.get(that.target()).
        success(function(data) {
          that.collection.reset(data);

          that.hideSpinner();
        });
    }
  });
}())
