class State < ActiveRecord::Base
  # include Singleton
  def self.preenrolled
    find_by_code('PRE')
  end
  def self.enrolled
    find_by_code('ENR')
  end
  def self.completed
    find_by_code('COM')
  end
  def self.deferred
    find_by_code('DEF')
  end

  def enrolled?
    code == 'ENR'
  end
end
