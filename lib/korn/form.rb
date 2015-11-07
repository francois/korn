require "coercible"

module Korn
  class Form
    def self.coercer
      @coercer ||= Coercible::Coercer.new
    end

    class Property
      def initialize(name, type_or_malias=nil, malias=nil)
        @name = name
        if type_or_malias.is_a?(Class) then
          @type = type_or_malias
          @malias = malias || name
        else
          @type = String
          @malias = type_or_malias || name
        end
      end

      attr_reader :name, :type, :malias

      def coerce(value)
        Korn::Form.coercer[String].public_send("to_#{type.name.downcase}", value)
      end
    end

    def self.property(name, type=nil, malias=nil)
      (@properties ||= Array.new) << Property.new(name, type, malias)
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
          attributes[prop.name.to_s] = model.public_send(prop.malias.to_sym)
        end
      end
    end

    def copy_to(model)
      model.tap do |m|
        self.class.instance_variable_get("@properties").each do |prop|
          value = attributes.fetch(prop.name.to_s)
          coerced_value = prop.coerce(value)
          model.public_send("#{prop.malias}=", coerced_value)
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
