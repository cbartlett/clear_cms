
ClearCms.Router.map(function() {
  this.resource('content', { path: '/contents/:content_id' })
    // this.resource('content_block'){;
});

ClearCMS.ContentsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('content');
  }
});

ClearCMS.ContentRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('content', params.content_id);
  }
});

// App.Router.map(function() {
//   this.resource('foo', function() {
//     this.resource('foo.bar', { path: '/bar' }, function() {
//       this.route('baz'); // This will be foo.bar.baz
//     });
//   });
// });

// Plan your routes according to your UI. If a route replaces another, it should should be represented at the same level in your router. If a route is to render on the same page as another route within the {{ outlet }} in its template, then you should nest that route in your Router.


// ClearCms.ContentRoute = Ember.Route.extend({
//   model: function() {
//     return ClearCms.Content.create(window.raw_cms_content);
//   }
// });
