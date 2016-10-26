require 'rails_helper'

describe HomeController do
  before do
    Timecop.freeze(Time.now)
  end

  context 'not exceeding the throttle limit' do
    describe '#index' do
      it 'should return the correct response' do
        expected_response = {
         "message" => 'ok'
        }

        get :index

        expect(JSON.parse(response.body)).to eq(expected_response)
      end

      it 'should return the correct response code' do
        get :index

        expect(response.code).to eq('200')
      end
    end
  end

  context 'exceeding the throttle limit' do
    describe '#index' do
      let!(:throttle_log) { create(:throttle_log, ip_address: '0.0.0.0', count: 100, expiry_time: Time.now + 1.hour ) }

      it 'should return the correct response' do
        expected_response = {
         "message" => 'Rate limit exceeded. Try again in 3600 seconds'
        }

        get :index

        expect(JSON.parse(response.body)).to eq(expected_response)
      end

      it 'should return the correct response code' do
        get :index

        expect(response.code).to eq('429')
      end
    end
  end
end
