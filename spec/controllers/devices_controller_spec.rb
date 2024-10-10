# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:api_key) { create(:api_key) }
  let(:user) { api_key.bearer }

  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: { new_device_owner_id: new_owner_id, serial_number: '123456' },
           session: { token: user.api_keys.first.token }
    end
    context 'when the user is authenticated' do
      context 'when user assigns a device to another user' do
        let(:new_owner_id) { create(:user).id }

        it 'returns an unauthorized response' do
          assign
          expect(response.code).to eq("422")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user assigns a device to self' do
        let(:new_owner_id) { user.id }
        let!(:device) { create(:device, serial_number: '123456', owner: nil) }

        it 'returns a success response' do
          assign
          expect(response).to be_successful
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :assign
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'POST #unassign' do
    subject(:unassign) do
      post :unassign,
          params: { from_user: from_user, serial_number: '123456' },
          session: { token: user.api_keys.first.token }
    end
    context 'when the user is authenticated' do
      context 'when user assigns a device to another user' do
        let(:from_user) { create(:user).id }

        it 'returns an unauthorized response' do
          unassign
          expect(response.code).to eq("422")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Unauthorized' })
        end
      end

      context 'when user returns device from self' do
        let(:from_user) { user.id }
        let!(:device) { create(:device, serial_number: '123456', owner: nil) }

        before do
          AssignDeviceToUser.new(
            requesting_user: user,
            serial_number: device.serial_number,
            new_device_owner_id: from_user
          ).call
        end

        it 'returns a success response' do
          unassign
          expect(response).to be_successful
        end
      end

      context 'when user tries to return device not belonging to him' do
        let(:from_user) { user.id }
        let(:other_user) { create(:user) }
        let!(:device) { create(:device, serial_number: '123456', owner: nil) }

        before do
          AssignDeviceToUser.new(
            requesting_user: other_user,
            serial_number: device.serial_number,
            new_device_owner_id: other_user.id
          ).call
        end

        it 'returns an unauthorized response' do
          unassign
          expect(response.code).to eq("422")
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Device is not assigned to You' })
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns an unauthorized response' do
        post :unassign
        expect(response).to be_unauthorized
      end
    end
  end
end
