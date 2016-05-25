module Api
  module V1
    class AttendancesController < ApplicationController

      def new
        user = User.find_by(check_token: params[:token])
        if user && user.activated?
          if !user.attendance.attend
            msg = { msg: "Welcom to Lab" }
            user.attendance.checkin
          else
            msg = { msg: "Already checked in" }
          end
        else
          msg = { msg: "Bad user or token" }
        end
        render json: msg
      end

      def destroy
        user = User.find_by(check_token: params[:token])
        if user && user.activated?
          if user.attendance.attend
            msg = { msg: "Goodbye" }
            user.attendance.checkout
          else
            msg = { msg: "Already checked out" }
          end
        else
          msg = { msg: "Bad user or token" }
        end
        render json: msg
      end

    end
  end
end
