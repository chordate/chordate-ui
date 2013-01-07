//= require_self
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views

c = {
  m: {},
  v: {},
  c: {},
  t: {},
  u: {
    navigate: function(where) {
      window.location = where;
    }
  },
  data: {},
  template: function(path) {
    return function(args) { return c.t[path](args); };
  }
};
