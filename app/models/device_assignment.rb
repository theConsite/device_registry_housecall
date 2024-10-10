class DeviceAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :device

  validates :user_id, presence: true
  validates :device_id, presence: true
end