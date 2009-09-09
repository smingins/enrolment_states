class StatusChange < ActiveRecord::Base
  belongs_to :enrolment
  belongs_to :state
  validate :approved_date_cannot_be_greater_than_today

  def approved_date_cannot_be_greater_than_today
    return false unless approved_date
    errors.add(:approved_date, "cannot be greater than today") if approved_date > Date.today
  end

end
