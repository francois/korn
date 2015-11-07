require "test_helper"
require "korn/form"

class KornBasicForm < MiniTest::Test
  class BasicForm < Korn::Form
    property :name
  end

  class Model
    attr_accessor :name
  end

  def test_maps_incoming_values_to_model
    form = BasicForm.new("name" => "My Name")
    model = form.copy_to(Model.new)
    assert_equal "My Name", model.name
  end
end
