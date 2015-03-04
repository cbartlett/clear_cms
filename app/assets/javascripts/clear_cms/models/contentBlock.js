ClearCms.ContentBlock = DS.Model.extend({
  primaryKey: '_id',
  body: DS.attr('string'),
  type: DS.attr('string'),
  content_assets: DS.hasMany('content_asset', {embedded: 'always'}),
});
