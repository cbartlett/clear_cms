
ClearCms.User = Ember.Object.extend({
  // init: function() {
  //   console.log('content says hello');
  // },
  // shouldn't these be API calls?
  content_types: <%= ClearCMS::Content.content_types.collect(&:to_s) %>,
  // authors: <%= ClearCMS::User.active.compact.uniq.to_json %>,
});

content = ClearCms.Content.create(window.raw_cms_content);
