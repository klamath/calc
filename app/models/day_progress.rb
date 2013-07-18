class DayProgress < ActiveRecord::Base
  attr_accessible :day, :progress

  def self.fill_random_data(event_days)
    event_days.sort!
    days = where(day: event_days).order(:day)
    new_db_days = {}
    db_days = days.collect{|d| d.day}
    days.each{|d| new_db_days[d.day] = d.progress }

    diff = event_days - db_days

    diff.each do |day|
      rnd = rand(99-5) + 5
      new_db_days[day] = rnd
      DayProgress.create(day: day, progress: rnd)
    end

    return new_db_days
  end
end
