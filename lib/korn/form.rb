module Korn
  class Form
    def self.property(name)
      (@properties ||= Array.new) << name
    end

    def initialize(attributes)
      @attributes = attributes
    end

    attr_reader :attributes

    def copy_to(model)
      model.tap do |m|
        self.class.instance_variable_get("@properties").each do |prop|
          model.public_send("#{prop}=", attributes.fetch(prop.to_s))
        end
      end
    end
  end
end
