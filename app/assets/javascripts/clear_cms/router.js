
ClearCms.Router.map(function() {
  this.resource('contents', function() {
    this.resource('content', {path: '/'}, function() {
      this.route('edit', {path: '/:content_id/edit'});
      this.route('show', {path: '/:content_id'});
    });
  });
});


ClearCms.ContentsEditRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('content', params.content_id);
  }
});

ClearCms.ContentsRoute = Ember.Route.extend({



});


