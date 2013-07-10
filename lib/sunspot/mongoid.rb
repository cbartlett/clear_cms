require 'sunspot'
require 'mongoid'
require 'sunspot/rails'

# == Examples:
#
# class Post
#   include Mongoid::Document
#   field :title
# 
#   include Sunspot::Mongoid
#   searchable do
#     text :title
#   end
# end
#
module Sunspot
  module Mongoid
    def self.included(base)
      base.class_eval do
        extend Sunspot::Rails::Searchable::ActsAsMethods
        Sunspot::Adapters::DataAccessor.register(DataAccessor, base)
        Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, base)
      end
    end

    class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
      def id
        @instance.id.to_s
      end
    end

    class DataAccessor < Sunspot::Adapters::DataAccessor
      def load(id)
        @clazz.criteria.for_ids(Moped::BSON::ObjectId(id))
      end

      def load_all(ids)
        #ids.map { |id| self.load(id) }
        @clazz.criteria.in(:_id => ids.map {|id| Moped::BSON::ObjectId(id)})
      end

#       private
# 
#       def criteria(id)
#         @clazz.criteria.id(id)
#       end
    end
  end
end



# module MongoidAdapter
#   class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
#     def id
#       @instance.id.to_s
#     end
#   end
# 
#   class DataAccessor < Sunspot::Adapters::DataAccessor
#     def load(id)
#       @clazz.criteria.for_ids(BSON::ObjectId(id))
#     end
# 
#     def load_all(ids)
#       @clazz.criteria.in(:_id => ids.map {|id| BSON::ObjectId(id)})
#     end
#   end
# end
# 
# Sunspot::Adapters::DataAccessor.register(MongoidAdapter::DataAccessor, Mongoid::Document)
# Sunspot::Adapters::InstanceAdapter.register(MongoidAdapter::InstanceAdapter, Mongoid::Document)