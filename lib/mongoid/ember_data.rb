module Mongoid
  module EmberData
    extend ActiveSupport::Concern
    
    module ClassMethods
      def ember_fields
        fields.collect do |key, value|
          {"#{key}": {
              ember_type: 'string',
              mongoid_field: value
            }
          }
        end 
      end

      def render_ember_model
        output=''
        fields.each do |key, value|
          output << "#{key}: DS.attr('#{ember_data_type(value)}'),\n"
        end
        output
      end

      def ember_data_type(field)
        'string'
      end
    end
  end
end