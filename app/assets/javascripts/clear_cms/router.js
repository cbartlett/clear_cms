
ClearCms.Router.map(function() {
  this.resource('contents', function() {
    this.resource('content', {path: '/'}, function() { 
      this.route('edit', {path: '/:content_id/edit'});
      this.route('show', {path: '/:content_id'});
    });
  });
});


ClearCms.ContentEditRoute = Ember.Route.extend({
  setupController: function(controller) {
    // Set the IndexController's `title`
    //controller.set('title', 'controller title');
    //console.log('in setup controller');
    controller.set('model', {first_name: 'Lastneem', title: 'hello'});
  },
  model: function(params) {
    console.log('in model in controler');
    //return {first_name: 'hello'} 
    return {title: 'router model title'};
  }
});

ClearCms.ContentsRoute = Ember.Route.extend({



});
