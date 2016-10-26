class AddIndexOnIpAddress < ActiveRecord::Migration[5.0]
  def change
    add_index :throttle_logs, :ip_address
  end
end
