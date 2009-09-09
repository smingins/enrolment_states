class CreateStatusChanges < ActiveRecord::Migration
  def self.up
    create_table :status_changes do |t|
      t.references :enrolment
      t.references :state
      t.date :effective_date
      t.date :approved_date

      t.timestamps
    end
  end

  def self.down
    drop_table :status_changes
  end
end
