ClearCms.ContentBlock = DS.Model.extend({
  primaryKey: '_id',
  content: DS.belongsTo('content',{embedded: 'always'}),
  body: DS.attr('string'),
  content_assets: DS.hasMany('content_asset', {embedded: 'always'}),
});