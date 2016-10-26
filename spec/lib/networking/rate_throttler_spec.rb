require 'rails_helper'

describe RateThrottler::ThrottleChecker do
  let(:throttle_checker) { RateThrottler::ThrottleChecker.new('test_ip_address') }

  context 'requested for the first time' do
    describe '#check_for_throttling' do
      it 'should create a throttle log' do
        throttle_checker.check_for_throttling

        expect(ThrottleLog.count).to eq 1
      end

      it 'should create a throttle log with count 1' do
        throttle_checker.check_for_throttling

        expect(ThrottleLog.last.count).to eq 1
      end

      it 'should return false for throttled' do
        result = throttle_checker.check_for_throttling

        expect(result[:throttle]).to eq false
      end
    end
  end

  context 'requested in subsequent times' do
    let!(:throttle_log) { create(:throttle_log, ip_address: 'test_ip_address', count: 45, expiry_time: Time.now + 1.hour ) }

    describe '#check_for_throttling' do
      it 'should not create a throttle log' do
        throttle_checker.check_for_throttling

        expect(ThrottleLog.count).to eq 1
      end

      it 'should return false for throttled' do
        result = throttle_checker.check_for_throttling

        expect(result[:throttle]).to eq false
      end
    end
  end

  context 'reaching the request limit' do
    let!(:throttle_log) { create(:throttle_log, ip_address: 'test_ip_address', count: 100, expiry_time: Time.now + 1.hour ) }

    describe '#check_for_throttling' do
      it 'should return true for throttled' do
        result = throttle_checker.check_for_throttling

        expect(result[:throttle]).to eq true
      end

      it 'should return the correct seconds difference' do
        result = throttle_checker.check_for_throttling

        expect(result[:throttle]).to eq true
      end
    end
  end

  context 'moving past the expiry time' do
    let!(:throttle_log) { create(:throttle_log, ip_address: 'test_ip_address', count: 100, expiry_time: Time.now + 1.hour ) }

    describe '#check_for_throttling' do
      it 'should return true for throttled (still before expiry time)' do
        result = throttle_checker.check_for_throttling

        expect(result[:throttle]).to eq true
      end

      it 'should return false for throttled (after expiry time)' do
        new_time = Time.now + 3.hours
        Timecop.travel(new_time)

        result = throttle_checker.check_for_throttling

        expect(result[:throttle]).to eq false
      end

      it 'reset the throttle log counter (after expiry time)' do
        new_time = Time.now + 3.hours
        Timecop.travel(new_time)

        throttle_checker.check_for_throttling

        expect(throttle_log.reload.count).to eq 1
      end
    end
  end
end
