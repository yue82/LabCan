module Api
  module V1
    class AttendancesController < ApplicationController
      before_action :correct_user, only: [:new, :destroy]

      def new
        user = User.find_by(check_token: params[:token])
        if !user.attendance.attend
          msg = { msg: "Welcom to Lab" }
          status = :success
          user.attendance.checkin
        else
          msg = { msg: "Already checked in" }
          status = :noupdate
        end
        render json: msg, status: status
      end

      def destroy
        user = User.find_by(check_token: params[:token])
        if user.attendance.attend
          msg = { msg: "Goodbye" }
          status = :success
          user.attendance.checkout
        else
          msg = { msg: "Already checked out" }
          status = :noupdate
        end
        render json: msg, status: status
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
