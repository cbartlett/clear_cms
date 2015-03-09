ClearCms.ContentSerializer = ClearCms.ApplicationSerializer.extend({
  attrs: {
    content_blocks: { embedded: 'always' },
  },
});

