ClearCms.Router.map(function() {
  this.route('support');
  this.resource('sites', function() {
    this.resource('site', {path: '/:site_id'}, function() {
      this.route('edit');
    });
  });
  this.resource('users', function() {
    this.resource('user', {path: '/:user_id'}, function() {
      this.route('edit');
      this.route('show');
    }); 
  });
  this.resource('contents', function() {
    this.resource('content', {path: '/:content_id'}, function() { 
      this.route('edit');
      this.route('show');
      this.route('raw');
    });
  });
});

// ClearCms.ContentEditRoute = Ember.Route.extend({
//   // setupController: function(controller) {
//   //   // Set the IndexController's `title`
//   //   //controller.set('title', 'controller title');
//   //   //console.log('in setup controller');
//   //   controller.set('model', {first_name: 'Lastneem', title: 'hello'});
//   // },
//   // model: function(params) {
//   //   console.log('in model in controler');
//   //   //return {first_name: 'hello'} 
//   //   return this.store.find('content', params.content_id);
//   // }
// });


// ClearCms.ContentShowRoute = Ember.Route.extend({
//   // model: function(params) {
//   //   return this.store.find('content', params.content_id);
//   // }
// });

// ClearCms.ContentsRoute = Ember.Route.extend({



// ClearCms.ContentsEditRoute = Ember.Route.extend({
//   model: function(params) {
//     return this.store.find('content', params.content_id);
//   }

// });
