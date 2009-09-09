class Enrolment < ActiveRecord::Base
  belongs_to :student
  belongs_to :state

  has_many :status_changes

  alias_method :original_state_assignment, :state=
  attr_accessor :previous_state

  validate :state_validation

  after_create :create_preenrolled_state_change

  def current_state
    state.try(:name)
  end

  def preenrol(effective_date = Date.today)
    self.state = State.preenrolled
    status_changes.build(:effective_date => effective_date, :state => State.preenrolled)
    save
  end

  def enrol(effective_date = Date.today)
    self.state = State.enrolled
    status_changes.build(:effective_date => effective_date, :state => State.enrolled)
    save
  end

  def complete(effective_date, approved_date)
    self.state = State.completed
    status_changes.build(:effective_date => effective_date, :approved_date => approved_date, :state => State.completed)
    save
  end

  def defer(new_start_date, approved_date)
    self.state = State.deferred
    status_changes.build(:effective_date => Date.today, :approved_date => approved_date, :state => State.deferred)
    save
    return false unless valid?
    self.state = State.enrolled
    self.start_date = new_start_date
    status_changes.build(:effective_date => new_start_date, :approved_date => approved_date, :state => State.enrolled)
    save
  end

  def state=(new_state)
    self.previous_state = self.state
    original_state_assignment(new_state)
  end

  def state_changed?
    state != previous_state
  end

  protected

    def state_validation
      case state.try(:code)
      when 'PRE'
      when 'ENR'
        errors.add(:start_date, 'is required') unless start_date
      when 'COM'
      when 'DEF'
        errors.add(:state, "change is invalid") unless previous_state.enrolled?
      else
        errors.add(:state, "is invalid")
      end
      common_validations
    end

    def common_validations
      errors.add(:state, "is already #{current_state}") unless state_changed?
    end

    def create_preenrolled_state_change
      status_changes.create!(:effective_date => start_date || Date.today, :state => State.preenrolled) if status_changes.empty?
    end

end
