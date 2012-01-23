require "active_record_stash/version"

module ActiveRecordStash
  # Your code goes here...
  extend ActiveSupport::Concern

  NO_TARGET_ERROR = "stashing needs a target serialized column. Supply an options hash with a :in key as the last argument (e.g. stash :apple, :in => :greeter)."

  included do |klass|
    class_attribute :stashed_attributes
    klass.stashed_attributes = Hash.new([])
    klass.after_initialize :_load_stashed_attributes
    klass.before_save :_stash_attributes
  end

  private
  def _load_stashed_attributes
    stashed_attributes.each_pair do |store_name,methods|

      return unless store = send(store_name)

      methods.each do |method|
        send :"#{method}=", store[method] if respond_to? method
      end

    end
  end

  def _stash_attributes
    stashed_attributes.each_pair do |store_name,methods|

      data = methods.inject({}) do |data,method|
        data[method] = send method
        data
      end

      self[store_name] = data
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

      self.stashed_attributes[serialized_column] += methods.map(&:to_sym)

      serialize serialized_column
      attr_accessor *methods
    end
  end
end

ActiveRecord::Base.send(:include,  ActiveRecordStash)
