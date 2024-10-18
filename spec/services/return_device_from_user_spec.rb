# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      user: user,
      serial_number: serial_number,
      from_user: from_user
    ).call
  end

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  context 'when users tries to return from another user' do
    let(:from_user) { create(:user).id }

    it 'raises an error' do
      expect { return_device }.to raise_error(RegistrationError::Unauthorized)
    end
  end

  context 'when users tries to return device not assigned to him' do
    let(:from_user) { user.id }
    let(:new_user) { create(:user) }
    let!(:device) { create(:device, serial_number: serial_number, owner: nil) }
    before do
      AssignDeviceToUser.new(
        requesting_user: new_user,
        serial_number: serial_number,
        new_device_owner_id: new_user.id,
        reason: 'Test zwrotów'
      ).call
    end

    it 'raises an error' do
      expect { return_device }.to raise_error(ReturningError::NotAssignedToUser)
    end
  end

  context 'when user returns device assigned to himself' do
    let!(:device) { create(:device, serial_number: serial_number, owner: nil) }
    let(:from_user) { user.id }
    before do
      AssignDeviceToUser.new(
        requesting_user: user,
        serial_number: serial_number,
        new_device_owner_id: user.id,
        reason: 'Test'
      ).call
      return_device
    end

    it 'clears device owner and saves assingment in history' do
      expect(device.owner_id).to be_nil
      expect(DeviceAssignment.exists?(user_id: from_user, device_id: device.id)).to be_truthy
    end
  end
end
