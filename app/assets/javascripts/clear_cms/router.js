# For more information see: http://emberjs.com/guides/routing/

ClearCms.Router.map(function() {
  this.resource('contents', { path: '/clear_cms/sites/:site_id/contents/:content_id/edit' });
});