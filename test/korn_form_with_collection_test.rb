require "test_helper"
require "korn/form"

class KornFormWithCollectionTest < MiniTest::Test
  class Parent
    attr_accessor :children, :name
  end

  class Child
    attr_accessor :name
  end

  class ParentForm < Korn::Form
    property :name
    collection :children, ->{ Child.new } do
      property :name
    end
  end

  def test_can_map_hash_values_to_nested_object
    form = ParentForm.new("name" => "Homer Simpson", "children" => [{"name" => "Bart Simpson"}])
    model = form.copy_to(Parent.new)
    assert_equal "Homer Simpson", model.name
    assert_equal ["Bart Simpson"], model.children.map(&:name)
  end

  def test_can_copy_a_model_into_a_hash
    model = Parent.new
    model.name = "Marge Simpson"
    model.children = 3.times.map{Child.new}
    model.children[0].name = "Bart Simpson"
    model.children[1].name = "Lisa Simpson"
    model.children[2].name = "Maggie Simpson"
    form = ParentForm.new.copy_from(model)
    assert_equal form.attributes, {"name" => "Marge Simpson", "children" => [{"name" => "Bart Simpson"}, {"name" => "Lisa Simpson"}, {"name" => "Maggie Simpson"}]}
  end
end
