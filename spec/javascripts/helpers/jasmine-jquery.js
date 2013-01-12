jasmine.JQuery = {
  matchersClass: {}
};

jasmine.JQuery.browserTagCaseIndependentHtml = function(html) {
  return $('<div/>').append(html).html()
};

jasmine.JQuery.elementToString = function(element) {
  var domEl = $(element).get(0)
  if (domEl == undefined || domEl.cloneNode)
    return $('<div />').append($(element).clone()).html()
  else
    return element.toString()
};

!function(){
  var jQueryMatchers = {
    toHaveClass: function(className) {
      return this.actual.hasClass(className)
    },

    toHaveCss: function(css){
      for (var prop in css){
        if (this.actual.css(prop) !== css[prop]) return false
      }
      return true
    },

    toBeVisible: function() {
      return this.actual.is(':visible')
    },

    toBeHidden: function() {
      return this.actual.is(':hidden')
    },

    toBeSelected: function() {
      return this.actual.is(':selected')
    },

    toBeChecked: function() {
      return this.actual.is(':checked')
    },

    toBeEmpty: function() {
      return this.actual.is(':empty')
    },

    toExist: function() {
      return $(this.actual).length
    },

    toHaveAttr: function(attributeName, expectedAttributeValue) {
      return hasProperty(this.actual.attr(attributeName), expectedAttributeValue)
    },

    toHaveProp: function(propertyName, expectedPropertyValue) {
      return hasProperty(this.actual.prop(propertyName), expectedPropertyValue)
    },

    toHaveId: function(id) {
      return this.actual.attr('id') == id
    },

    toHaveHtml: function(html) {
      return this.actual.html() == jasmine.JQuery.browserTagCaseIndependentHtml(html)
    },

    toContainHtml: function(html){
      var actualHtml = this.actual.html()
      var expectedHtml = jasmine.JQuery.browserTagCaseIndependentHtml(html)
      return (actualHtml.indexOf(expectedHtml) >= 0)
    },

    toHaveText: function(text) {
      var trimmedText = $.trim(this.actual.text())

      if (text && $.isFunction(trimmedText.match)) {
        return trimmedText.match(text)
      } else {
        return trimmedText == text
      }
    },

    toHaveValue: function(value) {
      return this.actual.val() == value
    },

    toHaveData: function(key, expectedValue) {
      return hasProperty(this.actual.data(key), expectedValue)
    },

    toBe: function(selector) {
      return this.actual.is(selector)
    },

    toContain: function(selector) {
      return this.actual.find(selector).length
    },

    toBeDisabled: function(selector){
      return this.actual.is(':disabled')
    },

    toBeFocused: function(selector) {
      return this.actual.is(':focus')
    },

    toHandle: function(event) {

      var events = $._data(this.actual.get(0), "events")

      if(!events || !event || typeof event !== "string") {
        return false
      }

      var namespaces = event.split(".")
      var eventType = namespaces.shift()
      var sortedNamespaces = namespaces.slice(0).sort()
      var namespaceRegExp = new RegExp("(^|\\.)" + sortedNamespaces.join("\\.(?:.*\\.)?") + "(\\.|$)")

      if(events[eventType] && namespaces.length) {
        for(var i = 0; i < events[eventType].length; i++) {
          var namespace = events[eventType][i].namespace
          if(namespaceRegExp.test(namespace)) {
            return true
          }
        }
      } else {
        return events[eventType] && events[eventType].length > 0
      }
    },

    // tests the existence of a specific event binding + handler
    toHandleWith: function(eventName, eventHandler) {
      var stack = $._data(this.actual.get(0), "events")[eventName]
      for (var i = 0; i < stack.length; i++) {
        if (stack[i].handler == eventHandler) return true
      }
      return false
    }
  }

  var hasProperty = function(actualValue, expectedValue) {
    if (expectedValue === undefined) return actualValue !== undefined
    return actualValue == expectedValue
  }

  var bindMatcher = function(methodName) {
    var builtInMatcher = jasmine.Matchers.prototype[methodName]

    jasmine.JQuery.matchersClass[methodName] = function() {
      if (this.actual
        && (this.actual instanceof $
        || jasmine.isDomNode(this.actual))) {
        this.actual = $(this.actual)
        var result = jQueryMatchers[methodName].apply(this, arguments)
        var element
        if (this.actual.get && (element = this.actual.get()[0]) && !$.isWindow(element) && element.tagName !== "HTML")
          this.actual = jasmine.JQuery.elementToString(this.actual)
        return result
      }

      if (builtInMatcher) {
        return builtInMatcher.apply(this, arguments)
      }

      return false
    }
  }

  for(var methodName in jQueryMatchers) {
    bindMatcher(methodName)
  }
}();

beforeEach(function() {
  this.addMatchers(jasmine.JQuery.matchersClass)
});
