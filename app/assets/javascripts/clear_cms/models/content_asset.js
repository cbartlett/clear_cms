ClearCms.ContentAsset = DS.Model.extend({
  //primaryKey: '_id',
  //content_block: DS.belongsTo('content_block'),
  file: DS.attr('string'),
  path: DS.attr('string'),
  title: DS.attr('string'),
  description: DS.attr('string'),
  credit: DS.attr('string'),
  tags: DS.attr('string'),
  order: DS.attr('number'),
  width: DS.attr('number'),
  height: DS.attr('number'),
  readonly_attributes: DS.attr(),
});
