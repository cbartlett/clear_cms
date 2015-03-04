ClearCms.UsersIndexRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('user');
  }
  
});