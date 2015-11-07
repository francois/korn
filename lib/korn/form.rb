module Korn
  class Form
    def self.property(name)
      (@properties ||= Array.new) << name
    end

    def initialize(attributes=nil)
      @attributes = attributes || Hash.new
    end

    # Attributes must *always* have String keys
    attr_reader :attributes

    def copy_from(model)
      self.tap do
        self.class.instance_variable_get("@properties").each do |prop|
          attributes[prop.to_s] = model.public_send(prop)
        end
      end
    end

    def copy_to(model)
      model.tap do |m|
        self.class.instance_variable_get("@properties").each do |prop|
          model.public_send("#{prop}=", attributes.fetch(prop.to_s))
        end
      end
    end

    def method_missing(selector, *args, &block)
      if attributes.include?(selector.to_s) then
        attributes.fetch(selector.to_s)
      else
        super(selector, *args, &block)
      end
    end

    def respond_to?(selector)
      attributes.include?(selector.to_s)
    end
  end
end
