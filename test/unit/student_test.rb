require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  test "save a new student without an enrolment" do
    student = Student.new(:name => "Fred")
    assert student.save
    assert_nil student.current_enrolment
    assert_equal 0, student.enrolments.count
    assert_nil student.current_enrolment_state
  end

  test "building a current enrolment" do
    student = Student.new(:name => "Fred")
    enrolment = student.build_current_enrolment
    assert student.save
    assert_equal enrolment, student.current_enrolment
    assert_equal 1, student.current_enrolment.status_changes.count
    assert_equal 1, student.enrolments.count
    assert_equal State.preenrolled, student.current_enrolment.state
  end

  test "saving a new student and enrolment" do
    student = Student.new(:name => 'Shane Mingins', :current_enrolment_attributes => {:start_date => '2010-01-01'})
    assert student.save
    assert_not_nil  student.current_enrolment
    assert_equal 1, student.current_enrolment.status_changes.count
    assert_equal 1, student.enrolments.count
    assert_equal State.preenrolled, student.current_enrolment.state
    assert_equal '2010-01-01'.to_date,  student.current_enrolment.start_date
  end

  test "updating an existing student and enrolment" do
    student = Student.create!(:name => 'Shane Mingins', :current_enrolment_attributes => {:start_date => '2010-01-01'})
    enrolment_id = student.current_enrolment.id
    assert student.update_attributes(:name => 'Shane Andre Mingins', :current_enrolment_attributes => {:id => enrolment_id, :start_date => '2010-11-01'})
    assert_equal 'Shane Andre Mingins', student.name
    assert_not_nil  student.current_enrolment
    assert_equal 1, student.enrolments.count
    assert_equal '2010-11-01'.to_date,  student.current_enrolment.start_date
    assert_equal State.preenrolled, student.current_enrolment.state
  end

  test "updating an existing student with a new enrolment" do
    student = Student.create!(:name => 'Shane Mingins', :current_enrolment_attributes => {:start_date => '2010-01-01'})
    assert student.update_attributes(:name => 'Shane Andre Mingins', :current_enrolment_attributes => {:start_date => '2010-11-01'})
    assert_equal 'Shane Andre Mingins', student.name
    assert_not_nil  student.current_enrolment
    assert_equal 2, student.enrolments.count
    assert_equal '2010-11-01'.to_date,  student.current_enrolment.start_date
    assert_equal State.preenrolled, student.current_enrolment.state
  end

  test "enrol a new student and enrolment" do
    student = Student.new(:name => 'Shane Mingins', :current_enrolment_attributes => {:start_date => '2010-01-01'})
    assert student.enrol
    assert_not_nil  student.current_enrolment
    assert_equal 1, student.current_enrolment.status_changes.count
    assert_equal 1, student.enrolments.count
    assert_equal State.enrolled, student.current_enrolment.state
    assert_equal '2010-01-01'.to_date,  student.current_enrolment.start_date
  end

  test "try to enrol twice" do
    student = Student.new(:name => 'Shane Mingins', :current_enrolment_attributes => {:start_date => '2010-01-01'})
    assert student.enrol
    assert !student.enrol
    assert student.invalid?
    assert student.current_enrolment.errors.on(:state)
  end

end
