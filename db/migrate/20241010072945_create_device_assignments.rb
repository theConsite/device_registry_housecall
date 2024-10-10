class CreateDeviceAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :device_assignments do |t|
      t.integer :user_id
      t.integer :device_id

      t.timestamps
    end

    add_index :device_assignments, :user_id
    add_index :device_assignments, :device_id
    add_index :device_assignments, [:user_id, :device_id], unique: true
    add_foreign_key :device_assignments, :users, column: :user_id
    add_foreign_key :device_assignments, :devices, column: :device_id

  end
end
