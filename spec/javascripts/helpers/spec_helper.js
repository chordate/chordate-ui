jasmine.createEventObj = function() {
  return jasmine.createSpyObj("Event", ["stopPropagation", "preventDefault"]);
};

beforeEach(function() {
  c.data = {};
  spyOn(c.u, "navigate");
  jasmine.Ajax.useMock();

  clearAjaxRequests();
});
