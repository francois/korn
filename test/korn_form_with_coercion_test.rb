require "test_helper"
require "bigdecimal"
require "date"
require "korn/form"
require "time"

class KornFormWithCoercionTest < MiniTest::Test
  class DateForm < Korn::Form
    property :valid_on, Date
  end
  class DateModel
    attr_accessor :valid_on
  end

  def test_assign_date_string_coerces_to_date
    form = DateForm.new("valid_on" => "2015-11-07")
    model = form.copy_to(DateModel.new)
    assert_equal Date.new(2015, 11, 7), model.valid_on
  end

  #
  ##################
  #

  class TimeForm < Korn::Form
    property :valid_at, Time
  end
  class TimeModel
    attr_accessor :valid_at
  end

  def test_assign_time_string_coerces_to_time
    form = TimeForm.new("valid_at" => "Sep 9, 2015 13:09-0400")
    model = form.copy_to(TimeModel.new)
    assert_equal Time.utc(2015, 9, 9, 17, 9, 0), model.valid_at
  end

  #
  ##################
  #

  class CoercionForm < Korn::Form
    property :age, Integer
    property :height_in_ft, Float
    property :amount, BigDecimal
  end
  class CoercionModel
    attr_accessor :age, :height_in_ft, :amount
  end

  def test_coerces_to_model
    form = CoercionForm.new("age" => "13", "height_in_ft" => "5.9", "amount" => "88.21")
    model = form.copy_to(CoercionModel.new)
    assert_kind_of Integer, model.age
    assert_kind_of Float, model.height_in_ft
    assert_kind_of BigDecimal, model.amount
  end
end
