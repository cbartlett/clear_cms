# Override the default adapter with the `DS.ActiveModelAdapter` which

ClearCms.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'clear_cms/sites/5230edc2e80e0f4508000002'
  primaryKey: '_id',
})

ClearCMS.ApplicationSerializer = DS.ActiveModelSerializer.extend({
  primaryKey: '_id',
})



ClearCMS.ContentSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  primaryKey: '_id',
  attrs: {
    content_blocks: { embedded: 'always' },
    # comments: { serialize: 'ids' }
  }
});


ClearCMS.ContentBlockSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  primaryKey: '_id',
  attrs: {
    content_assets: { embedded: 'always' },
    # comments: { serialize: 'ids' }
  }
});
