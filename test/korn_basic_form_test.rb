require "test_helper"
require "korn/form"

class KornBasicForm < MiniTest::Test
  class Model1Form < Korn::Form ; property :name ; end
  class Model1 ; attr_accessor :name ; end
  def test_maps_name_property_to_model
    form = Model1Form.new("name" => "My Name")
    model = form.copy_to(Model1.new)
    assert_equal "My Name", model.name
  end

  def test_reads_name_from_model
    model = Model1.new.tap{|m| m.name = "John Smith"}
    form = Model1Form.new.copy_from(model)
    assert_equal "John Smith", form.name
  end

  class Model2Form < Korn::Form
    property :name
    property :category
  end
  class Model2 ; attr_accessor :name, :category ; end
  def test_maps_name_and_category_to_model
    form = Model2Form.new("name" => "Francois", "category" => "developer")
    model = form.copy_to(Model2.new)
    assert_equal "Francois", model.name
    assert_equal "developer", model.category
  end

  def test_reads_name_and_category_from_model
    model = Model2.new.tap{|m| m.name = "Jane Smith" ; m.category = "assassin"}
    form = Model2Form.new.copy_from(model)
    assert_equal "Jane Smith", form.name
    assert_equal "assassin", form.category
  end
end
