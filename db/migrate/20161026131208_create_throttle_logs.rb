class CreateThrottleLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :throttle_logs do |t|
      t.string :ip_address, null: false
      t.datetime :expiry_time, null: false
      t.integer :count, null: false

      t.timestamps
    end
  end
end
