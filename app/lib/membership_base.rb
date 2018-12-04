module MembershipBase
  Airrecord.api_key = ENV['AIRTABLE_API_KEY']

  module AirrecordTableUtilities
    def self.included base
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module ClassMethods
      def map_field(method_name, field_name, read_only: false)
        define_method method_name do
          self[field_name]
        end
        
        if !read_only
          define_method "#{method_name.to_s}=" do |new_value|
            self[field_name] = new_value
          end
        end
      end

      def new_from_mapped_fields(fields, set_empty: true)
        record = self.new({})
        record.set_from_mapped_fields(fields, set_empty: set_empty)
        record
      end
    end

    module InstanceMethods
      def set_from_mapped_fields(fields, set_empty: true)
        fields.each do |field_name, new_value|
          # !set_empty && (new_value.nil? || new_value.empty?) => do nothing
          # !(!set_empty && (new_value.nil? || new_value.empty?) => set field
          # set_empty || !(new_value.nil? || new_value.empty?)
          if set_empty || !new_value.nil? && !new_value.empty?
            self.send("#{field_name.to_s}=", new_value)
          end
        end
      end

      def changed?
        !self.updated_keys.empty?
      end
    end
  end

  Airrecord::Table.include AirrecordTableUtilities
end
