ClearCms.ApplicationSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  primaryKey: '_id',
  attrs: {
    created_at: {serialize: false},
    updated_at: {serialize: false},
    readonly_attributes: {serialize: false},
  },
});