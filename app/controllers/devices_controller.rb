# frozen_string_literal: true

class DevicesController < ApplicationController
  before_action :authenticate_user!, only: %i[assign unassign]
  def assign
    AssignDeviceToUser.new(
      requesting_user: @current_user,
      serial_number: params[:serial_number],
      new_device_owner_id: params[:new_device_owner_id].to_i
    ).call
    head :ok
  rescue RegistrationError::Unauthorized => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def unassign
    ReturnDeviceFromUser.new(
      user: @user,
      serial_number: params[:serial_number],
      from_user: params[:from_user].to_i
    ).call
    head :ok
  rescue RegistrationError::Unauthorized => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def device_params
    params.permit(:new_owner_id, :serial_number)
  end
end
