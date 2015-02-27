ClearCms.Content = Ember.Object.extend({
  title: null,
  first_name: null,
  init: function() {
    this.set('title','setting title');
    console.log('content says hello');
  }
});
