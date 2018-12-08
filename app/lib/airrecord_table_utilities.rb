module AirrecordTableUtilities
  def self.included base
    base.extend ActiveModel::Naming
    base.include ActiveModel::AttributeAssignment
    base.include ActiveModel::Validations
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def map_field(method_name, field_name, read_only: false)
      define_method method_name do
        self[field_name]
      end
      
      if read_only
        define_method "#{method_name.to_s}=" do |new_value|
          new_value #no_op
        end
      else
        define_method "#{method_name.to_s}=" do |new_value|
          self[field_name] = new_value
        end
      end
    end

    def map_date_field(method_name, field_name, read_only: false)
      define_method method_name do |raw: false|
        value = self[field_name]
        unless value.nil? || raw
          value = Date.strptime(value, '%Y-%m-%d')
        end
        value
      end

      if read_only
        define_method "#{method_name.to_s}=" do |new_value|
          new_value
        end
      else
        define_method "#{method_name.to_s}=" do |new_value|
          if new_value.is_a? String
            self[field_name] = new_value
          elsif new_value.is_a? Date
            self[field_name] = new_value.strftime('%Y-%m-%d')
          else
            raise "Value of type #{new_value.class} not recognized!"
          end
        end
      end
    end

    def empty
      self.new({})
    end

    def new_assign_attributes(attributes)
      record = self.new({})
      record.assign_attributes(attributes)
      record
    end
  end

  module InstanceMethods
    def changed?
      !updated_keys.empty?
    end

    def update(fields)
      set_attributes(fields)
      if changed?
        save
        true
      else
        false
      end
    end
  end
end
