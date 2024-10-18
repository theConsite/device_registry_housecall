class AddReasonToDeviceAssingments < ActiveRecord::Migration[7.1]
  def change
    add_column :device_assignments, :reason, :string
  end
end
