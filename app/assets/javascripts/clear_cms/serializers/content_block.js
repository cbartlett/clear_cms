ClearCms.ContentBlockSerializer = ClearCms.ApplicationSerializer.extend({
  attrs: {
    content_assets: { embedded: 'always' },
  },
});
