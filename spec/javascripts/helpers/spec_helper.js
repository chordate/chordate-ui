jasmine.createEventObj = function() {
  return jasmine.createSpyObj("Event", ["stopPropagation", "preventDefault"]);
};

beforeEach(function() {
  jasmine.Ajax.useMock();
});
