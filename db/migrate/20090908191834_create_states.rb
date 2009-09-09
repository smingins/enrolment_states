class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :code
      t.string :name
      t.integer :level

      t.timestamps
    end

    State.create! :code => 'PRE', :level => 1, :name => 'Pre-enrolled'
    State.create! :code => 'ENR', :level => 2, :name => 'Enrolled'
    State.create! :code => 'COM', :level => 3, :name => 'Completed'
    State.create! :code => 'DEF', :level => 2, :name => 'Deferred'

  end

  def self.down
    drop_table :states
  end
end
