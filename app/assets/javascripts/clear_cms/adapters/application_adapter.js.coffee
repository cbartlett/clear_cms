# Override the default adapter with the `DS.ActiveModelAdapter` which

ClearCms.ApplicationAdapter = DS.RESTAdapter.extend({
  namespace: 'clear_cms/sites/5230edc2e80e0f4508000002'
  primaryKey: '_id',
})

ClearCMS.ApplicationSerializer = DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  primaryKey: '_id',
});



ClearCMS.ContentSerializer = DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    content_blocks: { embedded: 'always' },
    # comments: { serialize: 'ids' }
  },
  primaryKey: '_id',
});


ClearCMS.ContentBlocksSerializer = DS.RESTSerializer.extend(DS.EmbeddedRecordsMixin, {
  primaryKey: '_id',
  attrs: {
    content_assets: { embedded: 'always' },
    # comments: { serialize: 'ids' }
  }
});
