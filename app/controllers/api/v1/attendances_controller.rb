module Api
  module V1
    class AttendancesController < ApplicationController

      def new
        user = User.find(params[:id])
        if user && user.activated?
          if correct_token?(user, params[:token])
            if !user.attendance.attend
              msg = { msg: "Welcom to Lab" }
              user.attendance.labin
            else
              msg = { msg: "Already in Lab" }
            end
          else
            msg = { msg: "Bad Token" }
          end
        else
          msg = { msg: "Bad user" }
        end
          render json: msg
      end

      private
      def correct_token?(user, token)
        true
      end
    end
  end
end
