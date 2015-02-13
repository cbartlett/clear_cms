
ClearCms.Router.map(function() {
  this.resource('content', { path: '/contents/:content_id/edit' });
});


ClearCms.ContentRoute = Ember.Route.extend({
  model: function() {
    return ClearCms.Content.create(window.raw_cms_content);
  }
});
