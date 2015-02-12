ClearCms.contentController = Ember.Controller.extend({
  // the initial value of the `search` property
  search: '',

  model: function() {
  	alert('hi');
  },
  actions: {
    query: function() {
      // the current value of the text field
      var query = this.get('search');
      this.transitionToRoute('search', { query: query });
    }
  }
});