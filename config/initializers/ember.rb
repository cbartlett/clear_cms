#Setting the handlebars templates_root in ember rails so that it doesn't have clear_cms/content etc instead of just content.
#We might want to adjust this back depending on how we are namespacing
Rails.configuration.handlebars.templates_root = 'clear_cms/templates'