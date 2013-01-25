Handlebars.registerHelper('include', function(template, options) {
  var partial = Handlebars.partials[template];
  if(!partial) return "";

  var context = _({}).extend(options.hash);

  if(this.attributes && (this.attributes.id == this.id)) {
    _(context).extend(this.attributes);
  } else {
    _(context).extend(this);
  }

  return new Handlebars.SafeString(partial(context));
});

Handlebars.registerHelper('l', function(datetime, options) {
  var date = new Date(Date.parse(datetime));
  return new Handlebars.SafeString(I18n.l("date.formats." + options.hash.type, date));
});

Handlebars.registerHelper('t', function(key, options) {
  var items = options.hash && _(options.hash).keys().length && options.hash;

  if(items) return I18n.t(key, items);

  return I18n.t(key);
});
