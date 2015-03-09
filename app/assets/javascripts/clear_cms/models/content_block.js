ClearCms.ContentBlock = DS.Model.extend({
  //primaryKey: '_id',
  //content: DS.belongsTo('content'),
  body: DS.attr('string'),
  type: DS.attr('string'),
  has_gallery: DS.attr('boolean'),
  order: DS.attr('number'),
  content_assets: DS.hasMany('content_asset'),
});
