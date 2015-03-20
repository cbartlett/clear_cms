ClearCms.ContentEditController = Ember.ObjectController.extend({
  showDetails: false,
  actions: {
    toggleDetails: function() {
      var current = this.get('showDetails');
      if(current) {
        this.set('showDetails',false);
      } else {
        this.set('showDetails',true);
      }
    },
    addContentBlock: function() {
      this.get('model').get('content_blocks').createRecord({type: 'raw'});
    },
    save: function() {
      var content=this.get('model');
      content.save().then(
        function(response) { //success callback
          alert('successfully saved');
        },
        function(response) { //error callback
          alert(response);
        }
      );
    }
  }
});