
ClearCms.Router.map(function() {
  this.resource('content', { path: '/contents/:content_id' }, function() {
    this.route('edit');
    this.resource('content.content_block', { path: '/content_block' }, function(){
      this.route('edit')
      this.resource('content.content_block.content_asset', { path: '/content_asset'}, function(){
        this.route('edit')
        this.route('show')
      })
    })
  });
    // this.resource('content_block'){;
});


// App.Router.map(function() {
//   this.resource('foo', function() {
//     this.resource('foo.bar', { path: '/bar' }, function() {
//       this.route('baz'); // This will be foo.bar.baz
//     });
//   });
// });

// Plan your routes according to your UI. If a route replaces another, it should should be represented at the same level in your router. If a route is to render on the same page as another route within the {{ outlet }} in its template, then you should nest that route in your Router.


ClearCms.ContentRoute = Ember.Route.extend({
  model: function() {
    return ClearCms.Content.create(window.raw_cms_content);
  }
});
