ClearCms.ContentAsset = DS.Model.extend({
  primaryKey: '_id',
  content_block: DS.belongsTo('content_block', {embedded: 'always'}),
  file: DS.attr('string'),
  path: DS.attr('string'),
});
