ClearCms.ContentsController = Ember.Controller.extend({
  queryParams: 'page',
  page: 1,
  filteredArticles: function() {
    var page = this.get('page');
    var contents = this.get('model');

    if (page) {
      return contents.filterBy('page', page);
    } else {
      return contents;
    }
  }.property('page', 'model'),
});