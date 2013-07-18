class CreateDayProgresses < ActiveRecord::Migration
  def up
    create_table :day_progresses do |t|
      t.date :day
      t.integer :progress
      t.timestamps
    end
    add_index :day_progresses, :day, :unique => true
  end

  def down
    drop_table :day_progresses
  end
end
