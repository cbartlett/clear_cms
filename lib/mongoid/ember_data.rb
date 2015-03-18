module Mongoid
  module EmberData
    extend ActiveSupport::Concern

    included do 
      after_save :notify_pubsub
    end

private
    def notify_pubsub
      unless self.embedded?
        model = self.kind_of?(::ClearCMS::Content) ? self.class.superclass.name.demodulize.downcase! : self.class.name.demodulize.downcase!
        ClearCMS::PubSub.publish({'model': model, '_id': self.id}.to_json)
      end
    end
        
    class_methods do 

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
          unless key=='_id' # ember models are already expecting this as defined by primary_key: _id, so don't add to model definition
            output << "#{key}: DS.attr('#{ember_data_type(value)}'),\n"
          end
        end
        output << "readonly_attributes: DS.attr(),\n" # give every model a default readonly_attributes space that won't be serialized
      
        embedded_relations.each do |key, value|
          output << "#{key}: #{ember_relationship_type(value)},\n"
        end

        output
      end

      def ember_data_type(field)
        #string, number, boolean, and date
        case field.type.to_s 
          when 'Mongoid::Boolean'
            'boolean'
          when 'Time', 'DateTime'
            'date'
          when 'Array' 
            ''
          when 'Integer', 'Float'
            'number'
          else
            'string'
        end
      end

      def ember_relationship_type(relation)
        case relation.relation.to_s
        when 'Mongoid::Relations::Embedded::Many'
          "DS.hasMany('#{relation.key.singularize}')"
        else
          raise "RelationNotDefined"
        end
      end
    
    end # ClassMethods
  end
end