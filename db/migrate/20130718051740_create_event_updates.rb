class CreateEventUpdates < ActiveRecord::Migration
  def change
    create_table :event_updates do |t|
      t.datetime :updated_at
      t.integer :records
      t.string :message

      t.timestamps
    end
  end
end
