ClearCms.ContentAsset = DS.Model.extend({
  primaryKey: '_id',
  //content_block: DS.belongsTo('content_block', {embedded: 'always'}),
  file: DS.attr('string'),
  path: DS.attr('string'),
  title: DS.attr('string'),
  description: DS.attr('string'),
  credit: DS.attr('string'),
  tags: DS.attr(),
  order: DS.attr('number'),
  width: DS.attr('number'),
  height: DS.attr('number'),
  mounted_file: DS.attr(),
});
