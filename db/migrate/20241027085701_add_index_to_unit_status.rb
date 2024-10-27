class AddIndexToUnitStatus < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :chapters, :status, algorithm: :concurrently
    add_index :episodes, :status, algorithm: :concurrently
  end
end
