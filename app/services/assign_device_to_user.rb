# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:, reason:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
    @reason = reason
  end

  def call

    if @new_device_owner_id != @requesting_user.id
      raise RegistrationError::Unauthorized, 'Unauthorized'
    end

    device = Device.find_by(serial_number: @serial_number)
    raise RegistrationError::DeviceNotFound, 'Device not found' unless device

    if DeviceAssignment.exists?(user_id: @new_device_owner_id, device_id: device.id)
      raise AssigningError::AlreadyUsedOnUser, 'User already used device in the past'
    end

    if device.owner_id != nil && @requesting_user.id
      raise AssigningError::AlreadyUsedOnOtherUser, 'Device is assigned to another user'
    end

    device.update!(owner_id: @new_device_owner_id)
    DeviceAssignment.create!(user_id: @new_device_owner_id, device_id: device.id, reason: @reason)

  end
end
