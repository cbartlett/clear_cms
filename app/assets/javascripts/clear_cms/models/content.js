ClearCms.Content = DS.Model.extend({
  init: function() {
    this.set('title','setting title');
    console.log('content says hello');
  },
  // primaryKey: '_id',
  basename: DS.attr('string'),
  content_blocks: DS.hasMany('content_block', {embedded: 'always'}),
  title: DS.attr('string'),
  _type: DS.attr('string')

});
