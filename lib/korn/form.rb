require "coercible"

module Korn
  class Form
    def self.coercer
      @coercer ||= Coercible::Coercer.new
    end

    Collection = Struct.new(:name, :anon, :model_instantiator) do
      def copy_attrs_to_model(attributes, model)
        children = (attributes[name.to_s] || []).
          map{|attrs| anon.new(attrs).copy_to(model_instantiator.call)}
        model.public_send("#{name}=", children)
      end

      def copy_model_to_attrs(model, attributes)
        children = model.public_send(name.to_sym).
          map{|child| anon.new.copy_from(child).attributes}
        attributes[name.to_s] = children
      end
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

      def copy_attrs_to_model(attributes, model)
        value = attributes.fetch(name.to_s)
        coerced_value = coerce(value)
        model.public_send("#{malias}=", coerced_value)
      end

      def copy_model_to_attrs(model, attributes)
        attributes[name.to_s] = model.public_send(malias.to_sym)
      end

      def coerce(value)
        case type.name.downcase
        when "bigdecimal"
          Korn::Form.coercer[String].public_send("to_decimal", value)
        else
          Korn::Form.coercer[String].public_send("to_#{type.name.downcase}", value)
        end
      end
    end

    def self.collection(name, model_instantiator, &block)
      anon = Class.new(self)
      anon.instance_eval(&block)
      (@properties ||= Array.new) << Collection.new(name, anon, model_instantiator)
    end

    def self.property(name, type=nil, malias=nil)
      (@properties ||= Array.new) << Property.new(name, type, malias)
    end

    def initialize(attributes=nil)
      @attributes = attributes || Hash.new
    end

    # Attributes must *always* have String keys.
    # Values must *always* be instances of Property or Collection.
    # In fact, values must support the #copy_model_to_attrs and #copy_attrs_to_model methods.
    attr_reader :attributes

    # @return The Form instance
    # @api public
    def copy_from(model)
      self.class.instance_variable_get("@properties").
        each{|prop| prop.copy_model_to_attrs(model, attributes)}
      self
    end

    # @return The model
    # @api public
    def copy_to(model)
      self.class.instance_variable_get("@properties").
        each{|prop| prop.copy_attrs_to_model(attributes, model)}
      model
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
