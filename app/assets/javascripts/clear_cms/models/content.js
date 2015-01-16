
ClearCms.Content = Ember.Object.extend({
  init: function() {
    console.log('content says hello');
  }
});

content = ClearCms.Content.create(window.raw_cms_content);
