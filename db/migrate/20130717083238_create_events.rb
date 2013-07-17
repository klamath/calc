class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.string :title
      t.text :description
      t.datetime :date_start
      t.datetime :date_end

      t.timestamps
    end
  end
end
