module Korn
  class Form
    def self.property(name)
    end

    def initialize(attributes)
      @attributes = attributes
    end

    attr_reader :attributes

    def copy_to(model)
      model.name = attributes.fetch("name")
      model
    end
  end
end
