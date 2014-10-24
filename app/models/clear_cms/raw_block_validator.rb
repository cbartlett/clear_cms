classRawBlockValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  	content_block_types = []
      record.attribute.each { |cb| content_block_types<<cb.type }
      unless content_block_types.include?("raw")
        record.errors[attribute] << (options[:message] || 'need at least one "raw" type')
        return false
      end
  end
end