module Api
  module V1
    class AttendancesController < ApplicationController
      before_action :correct_user, only: [:new, :destroy]

      def new
        user = User.find_by(check_token: params[:token])
        status, res = user.attendance.checkin
        render json: res, status: status
      end

      def destroy
        user = User.find_by(check_token: params[:token])
        status, res = user.attendance.checkout
        if status == :success
          announce_last(last_one_user)
        end
        render json: res, status: status
      end

      private
      def correct_user
        user = User.find_by(check_token: params[:token])
        if !user || !user.activated?
          msg = { msg: "Bad user or token" }
          status = :error
          render json: msg, status: status
        end
      end
    end
  end
end
