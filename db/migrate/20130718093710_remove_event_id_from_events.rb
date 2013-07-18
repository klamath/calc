class RemoveEventIdFromEvents < ActiveRecord::Migration

  def up
    remove_column :events, :event_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
