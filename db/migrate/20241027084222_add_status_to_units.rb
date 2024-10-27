class AddStatusToUnits < ActiveRecord::Migration[6.1]
  using UpdateInBatches

  def change
    add_column :chapters, :status, :integer
    add_column :episodes, :status, :integer
    Chapter.all.update_in_batches(status: 0)
    Episode.all.update_in_batches(status: 0)
    change_column :chapters, :status, :integer, null: false, default: 0
    change_column :episodes, :status, :integer, null: false, default: 0
  end
end
