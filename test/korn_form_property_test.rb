require "test_helper"
require "korn/form"

class PropertyTest < MiniTest::Test
  Prop = Korn::Form::Property

  def test_name_returns_name
    prop = Prop.new(:category_code)
    assert_equal :category_code, prop.name
  end

  def test_type_defaults_to_string
    assert_equal String, Prop.new(:a).type
  end

  def test_malias_defaults_to_name
    assert_equal :start_on, Prop.new(:start_on).malias
  end

  def test_can_instantiate_without_type_which_then_defaults_to_string
    prop = Prop.new(:name, :alias)
    assert_equal :name, prop.name
    assert_equal String, prop.type
    assert_equal :alias, prop.malias
  end
end
