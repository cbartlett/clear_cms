ClearCms.ContentRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('content', params.content_id);
  }
});
