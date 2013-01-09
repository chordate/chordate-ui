jasmine.createEventObj = function() {
  return jasmine.createSpyObj("Event", ["stopPropagation", "preventDefault"]);
};

beforeEach(function() {
  spyOn(c.u, "navigate");
  jasmine.Ajax.useMock();
});
