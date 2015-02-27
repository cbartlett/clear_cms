ClearCms.ContentSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    content_blocks: { embedded: 'always' },
  },
});

