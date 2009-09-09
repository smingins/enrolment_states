class Student < ActiveRecord::Base
  has_many :enrolments
  has_many :status_changes, :through => :enrolments
  belongs_to :current_enrolment, :class_name => 'Enrolment'

  accepts_nested_attributes_for :current_enrolment
  alias_method :original_build_current_enrolment, :build_current_enrolment

  after_save :set_student_on_current_enrolment
  delegate :state, :to => :current_enrolment, :prefix => true, :allow_nil => true

  validates_presence_of :name

  def build_current_enrolment(attributes={})
    original_build_current_enrolment(attributes.merge(:state => State.preenrolled))
  end

  def set_student_on_current_enrolment
    current_enrolment.update_attribute(:student_id, self.id) if current_enrolment && current_enrolment.student.nil?
  end

  def enrol
    current_enrolment.state = State.enrolled
    current_enrolment.status_changes.build(:effective_date => current_enrolment.start_date || Date.today, :state => State.enrolled)
    save
  end

  def can_enrol?
    current_enrolment_state.nil? || current_enrolment_state == State.preenrolled || current_enrolment.new_record?
  end
end
