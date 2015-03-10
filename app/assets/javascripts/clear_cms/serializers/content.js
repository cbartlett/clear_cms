ClearCms.ContentSerializer = ClearCms.ApplicationSerializer.extend({
  attrs: {
    content_blocks: { embedded: 'always' },
  },
  serialize: function(snapshot, options) {
	var json = this._super(snapshot, options);

	json.content_blocks_attributes = json.content_blocks; 
	delete json.content_blocks; 

	forEach(json.content_blocks_attributes, function(item) {
		item.content_assets_attributes = item.content_assets;
		delete item.content_assets; 
	});

	return json;
	},
});

