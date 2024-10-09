# frozen_string_literal: true

module RegistrationError
  class Unauthorized < StandardError; end
  class DeviceNotFound < StandardError; end
end