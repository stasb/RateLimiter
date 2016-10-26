# == Schema Information
#
# Table name: throttle_logs
#
#  id          :integer          not null, primary key
#  ip_address  :string           not null
#  expiry_time :datetime         not null
#  count       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ThrottleLog < ActiveRecord::Base
end
