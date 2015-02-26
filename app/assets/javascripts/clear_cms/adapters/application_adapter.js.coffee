# Override the default adapter with the `DS.ActiveModelAdapter` which

ClearCms.ApplicationAdapter = DS.RESTAdapter.extend({
  namespace: 'clear_cms/sites/5230edc2e80e0f4508000002'
  primaryKey: '_id',
})

ClearCMS.ApplicationSerializer = DS.RESTSerializer.extend({
  primaryKey: '_id',
})
