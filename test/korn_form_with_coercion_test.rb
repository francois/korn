require "test_helper"
require "date"
require "time"
require "korn/form"

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
end
