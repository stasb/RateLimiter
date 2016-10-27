require 'rails_helper'

describe ThrottleLogCleaner do
  context 'with a non-expired log' do
    let!(:throttle_log) { create(:throttle_log, ip_address: 'test_ip_address', count: 45, expiry_time: Time.now + 1.hour ) }

    describe '.clean_throttle_logs' do
      it 'should leave the log intact' do
        ThrottleLogCleaner.clean_throttle_logs

        expect(ThrottleLog.count).to eq 1
      end
    end
  end

  context 'with an expired log' do
    let!(:throttle_log) { create(:throttle_log, ip_address: 'test_ip_address', count: 45, expiry_time: Time.now + 1.hour ) }

    describe '.clean_throttle_logs' do
      before do
        new_time = Time.now + 3.hours

        Timecop.travel(new_time)
      end

      it 'should destroy the log' do
        ThrottleLogCleaner.clean_throttle_logs

        expect(ThrottleLog.count).to eq 0
      end
    end
  end
end
