ClearCms.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  //TODO: fix namespacing to not hardcode site_id
  init: function(){
    _super();
    console.log('adapter loaded');
  },
  namespace: 'clear_cms/sites/5230edc2e80e0f4508000002',
  primaryKey: '_id',
});
