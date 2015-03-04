ClearCms.ContentAsset = DS.Model.extend({
  primaryKey: '_id',
  file: DS.attr('string'),
  path: DS.attr('string'),
  mounted_file: DS.attr(),
});
