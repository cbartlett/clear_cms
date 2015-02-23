// Define parent view
App.ContentBlockView = Ember.View.extend({
  templateName: 'content_block',

  // Define child view
  contentAssetView = Ember.View.extend({
    templateName: 'content_asset',
  });

});

