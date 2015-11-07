require "test_helper"
require "korn/form"

class KornFormWithAlias < MiniTest::Test
  class Model ; attr_accessor :value ; end
  class Form < Korn::Form
    # assign "valid_on" property from the form to the #value= accessor
    property :valid_on, :value
  end

  def test_assigns_value_on_the_model_from_valid_on_hash_property
    form = Form.new("valid_on" => "111", "value" => "222")
    model = form.copy_to(Model.new)
    assert_equal "111", model.value
  end

  def test_reads_value_from_aliased_model_field
    model = Model.new.tap{|m| m.value = "this"}
    form = Form.new.copy_from(model)
    assert_equal "this", form.valid_on
  end
end
