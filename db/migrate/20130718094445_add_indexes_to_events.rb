class AddIndexesToEvents < ActiveRecord::Migration
  def change
    add_index :events, :date_start
    add_index :events, :date_end
  end
end
