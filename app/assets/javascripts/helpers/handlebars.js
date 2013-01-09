Handlebars.registerHelper('include', function(template, options){
  var partial = Handlebars.partials[template];
  if(!partial) return "";

  var context = _({}).extend(this, options.hash);
  return new Handlebars.SafeString(partial(context));
});
