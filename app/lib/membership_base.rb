module MembershipBase
  Airrecord.api_key = ENV['AIRTABLE_API_KEY']

  module AirrecordTableUtilities
    def self.included base
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module ClassMethods
      def map_field(method_name, field_name)
        define_method method_name do
          self[field_name]
        end
        
        define_method "#{method_name.to_s}=" do |new_value|
          self[field_name] = new_value
        end
      end

      def new_from_mapped_fields(fields)
        record = self.new({})
        record.set_from_mapped_fields(fields)
        record
      end
    end

    module InstanceMethods
      def set_from_mapped_fields(fields)
        fields.each do |field_name, new_value|
          self.send("#{field_name.to_s}=", new_value)
        end
      end

      def changed?
        !self.updated_keys.empty?
      end
    end
  end

  Airrecord::Table.include AirrecordTableUtilities
end
