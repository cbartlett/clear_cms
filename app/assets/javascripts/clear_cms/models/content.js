ClearCms.Content = DS.Model.extend({

  primaryKey: '_id',
  basename: DS.attr('string'),
  content_blocks: DS.hasMany('content_block', {embedded: 'always'}),
  title: DS.attr('string'),
  _type: DS.attr('string')

});

ClearCms.Content.FIXTURES = [
 {
   id: 1,
   title: 'Learn Ember.js',
   isCompleted: true
 },
 {
   id: 2,
   title: '...',
   isCompleted: false
 },
 {
   id: 3,
   title: 'Profit!',
   isCompleted: false
 }
];
