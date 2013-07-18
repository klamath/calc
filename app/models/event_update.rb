class EventUpdate < ActiveRecord::Base
  attr_accessible :message, :records, :updated_at

  def self.last_successfull_time
    EventUpdate.find(:last, conditions: ['records IS NOT NULL']).try(:updated_at)
  end

end
