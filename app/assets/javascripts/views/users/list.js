c.v.UsersListView = (function() {
  return c.v.TableView.extend({
    title: "Users",
    headers: ["Name", "Email"],
    row: "_users_list_row",
    new: "_users_list_new",
    paginate: false,

    target: function(options) {
      options || (options = {});

      var type = options.type || "user";

      return "/applications/" + c.data.application.id + "/" + type + "s.json";
    },

    tableEvents: {
      "click #new-invite a": "invite",
      "submit form": "submitInvite"
    },

    init: function() {
      var that = this;

      $.get(that.target()).
        success(function(data) {
          that.collection.reset(data);

          that.hideSpinner();
        });
    },

    invite: function() {
      this.$("form").removeClass("hidden");
    },

    submitInvite: function(e) {
      var that = this,
          $submit = that.$("input[type='submit']"),
          $spinner = that.$("form .spinner"),
          $email = that.$(".email"),
          options = { email: $email.val() };

      that.stopPropagation(e);

      $submit.addClass("hidden");
      $spinner.removeClass("hidden");

      $.post(that.target({type: "invite"}), options).
        success(function() {
          $spinner.addClass("hidden");
          $submit.removeClass("hidden");

          $email.val("");
          that.$(".success").removeClass("hidden");
        });
    }
  });
}())
