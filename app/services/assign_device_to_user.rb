# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call

    if @new_device_owner_id != @requesting_user.id
      raise RegistrationError::Unauthorized, 'You cannot assign devices to other users'
    end

    device = Device.find_by(serial_number: @serial_number)
    raise RegistrationError::DeviceNotFound, 'Device not found' unless device

    device.update!(owner_id: @new_device_owner_id)

  end
end
