
ClearCms.ContentBlockSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  primaryKey: '_id',
  attrs: {
    content_assets: { embedded: 'always' }
  }
});
