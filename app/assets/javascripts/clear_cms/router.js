ClearCms.Router.map(function() {
  this.route('support');
  this.resource('contents', function() {
    this.resource('content', {path: '/:content_id'}, function() {
      this.route('edit');
      this.route('show');
      this.route('raw');
    });
  });
});



// ClearCms.ContentsEditRoute = Ember.Route.extend({
//   model: function(params) {
//     return this.store.find('content', params.content_id);
//   }
// });
