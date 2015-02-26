
ClearCms.Router.map(function() {
  this.resource('content', { path: '/contents/:content_id/edit' });

});


ClearCms.ContentRoute = Ember.Route.extend({
   setupController: function(controller) {
    // Set the IndexController's `title`
    controller.set('title', 'My Content');
  },
  model: function() {
    return ClearCms.Content.create();
  }
});
