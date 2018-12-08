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

    def new_from_mapped_fields(fields, set_empty: false)
      record = self.new({})
      record.set_from_mapped_fields(fields, set_empty: set_empty)
      record
    end

    def empty
      self.new({})
    end

  end

  module InstanceMethods
    def set_from_mapped_fields(fields, set_empty: false)
      fields.each do |field_name, new_value|
        # !set_empty && (new_value.nil? || new_value.empty?) => do nothing
        # !(!set_empty && (new_value.nil? || new_value.empty?) => set field
        # set_empty || !(new_value.nil? || new_value.empty?)
        if set_empty || !new_value.nil? && !new_value.empty?
          if self.respond_to? field_name
            self.send("#{field_name.to_s}=", new_value)
          end
        end
      end
    end

    def changed?
      !updated_keys.empty?
    end

    def update(fields)
      set_from_mapped_fields(fields)
      if changed?
        save
        true
      else
        false
      end
    end
  end
end
