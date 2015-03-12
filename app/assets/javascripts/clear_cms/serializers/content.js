ClearCms.ContentSerializer = ClearCms.ApplicationSerializer.extend({
  attrs: {
    content_blocks: { embedded: 'always' },
  },
  //To get Mongoid to UPDATE instead of CREATE for embedded relationships, we need to pass them as _attributes on the main save/submit
  //Mongoid uses the IDs to map them to the existing values and updates using array syntax content_blocks.0.updated_at etc
  //Check for and remove empty arrays, because Rails will set them to nil and then throw an error when it can't enumerate
  serialize: function(snapshot, options) {
	var json = this._super(snapshot, options);

	json.content_blocks_attributes = json.content_blocks; 
	delete json.content_blocks; 

	json.content_blocks_attributes.forEach(function(item) {
		if(item.content_assets.length) {
      item.content_assets_attributes = item.content_assets;
		}
    delete item.content_assets; 
	});

	return json;
	},
});

