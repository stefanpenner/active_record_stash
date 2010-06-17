
module ActiveRecord
  module StashInSerializedHash

    extend ActiveSupport::Concern

    NO_TARGET_ERROR = "stashing needs a target serialized column. Supply an options hash with a :in key as the last argument (e.g. stash :apple, :in => :greeter)."
  
    included do
      class_inheritable_accessor :stashed_attributes
      self.stashed_attributes = Hash.new([])

      after_initialize :_load_stashed_attributes
      before_save :_stash_attributes
    end
    
    private
    def _load_stashed_attributes
      stashed_attributes.each_pair do |store_name,methods|
        store = send(store_name)

        next unless store

        methods.each do |method|
          send :"#{method}=", store[method] unless send(method)
        end

      end
    end

    def _stash_attributes
      stashed_attributes.each_pair do |store_name,methods|

        eval "self.#{store_name} ||= {}"

        methods.each do |method|
          send(store_name)[method] = send method
        end

      end
    end

    module ClassMethods

      def stash *methods
        options = methods.extract_options!
        options.assert_valid_keys(:in)
        options.symbolize_keys!
  
        unless serialized_column = options[:in]
          raise ArgumentError,  NO_TARGET_ERROR
        end
 
        stashed_attributes[serialized_column] += methods.map(&:to_sym)

        serialize serialized_column
        attr_accessor *methods
      end
    end
  end
end

ActiveRecord::Base.send(:include,  ActiveRecord::StashInSerializedHash)


