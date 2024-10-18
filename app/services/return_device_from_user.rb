# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:, from_user:)
    @user= user
    @serial_number = serial_number
    @from_user = from_user
  end

  def call

    if @from_user != @user.id
      raise RegistrationError::Unauthorized, 'Unauthorized'
    end

    device = Device.find_by(serial_number: @serial_number)
    raise RegistrationError::DeviceNotFound, 'Device not found' unless device

    if device.owner_id == nil || @from_user != device.owner_id
      raise ReturningError::NotAssignedToUser, 'Device is not assigned to You'
    end

    device.update!(owner_id: nil)
  end
end
