require "coercible"

module Korn
  class Form
    def self.coercer
      @coercer ||= Coercible::Coercer.new
    end

    Property = Struct.new(:name, :type) do
      def coerce(value)
        Korn::Form.coercer[String].public_send("to_#{type.name.downcase}", value)
      end
    end

    def self.property(name, type=nil)
      (@properties ||= Array.new) << Property.new(name, type || String)
    end

    def initialize(attributes=nil)
      @attributes = attributes || Hash.new
    end

    # Attributes must *always* have String keys
    # Values must *always* be instances of Property
    attr_reader :attributes

    def copy_from(model)
      self.tap do
        self.class.instance_variable_get("@properties").each do |prop|
          attributes[prop.name.to_s] = model.public_send(prop.name.to_sym)
        end
      end
    end

    def copy_to(model)
      model.tap do |m|
        self.class.instance_variable_get("@properties").each do |prop|
          value = attributes.fetch(prop.name.to_s)
          coerced_value = prop.coerce(value)
          model.public_send("#{prop.name}=", coerced_value)
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
