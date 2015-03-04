ClearCms.Content = DS.Model.extend({

  primaryKey: '_id',
  basename: DS.attr('string'),
  content_blocks: DS.hasMany('content_block', {embedded: 'always'}),
  //author: DS.hasOne('user'),
  title: DS.attr('string'),
  _type: DS.attr('string')


});
