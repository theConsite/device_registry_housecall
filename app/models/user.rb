class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_secure_password
  has_many :devices, foreign_key: 'owner_id'
  has_many :device_assignments
end
