require 'test_helper'

class EnrolmentTest < ActiveSupport::TestCase
  test "new enrolment with no state is invalid" do
    enrolment = Enrolment.new
    assert enrolment.invalid?
  end

  test "new enrolment with pre_enrolled state is valid" do
    enrolment = Enrolment.new(:state => State.preenrolled)
    assert enrolment.valid?
  end

  test "new enrolment with enrolled state is invalid without start date" do
    enrolment = Enrolment.new(:state => State.enrolled)
    assert enrolment.invalid?
  end

  test "new enrolment with enrolled state and start date is valid" do
    enrolment = Enrolment.new(:state => State.enrolled, :start_date => Date.today)
    assert enrolment.valid?
  end

  test "deferring an enrolment 10 days" do
    enrolment = Enrolment.create!(:state => State.enrolled, :start_date => Date.today)
    enrolment.defer(Date.today + 10, Date.today)

    assert enrolment.valid?
    assert_equal Date.today + 10, enrolment.start_date
    assert_equal State.enrolled, enrolment.state
    assert_equal 3, enrolment.status_changes.count
  end

  test "deferring an enrolment that is preenrolled should be invalid" do
    enrolment = Enrolment.create!(:state => State.preenrolled, :start_date => Date.today)
    enrolment.defer(Date.today + 10, Date.today)

    assert enrolment.invalid?
    assert enrolment.errors.on(:state)
  end

end
