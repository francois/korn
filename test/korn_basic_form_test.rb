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
end
