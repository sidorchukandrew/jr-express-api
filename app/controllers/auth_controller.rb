class AuthController < ApplicationController

    def login
        @current_user = User.find_by(name: params[:name]&.downcase)

        if @current_user && @current_user.authenticate(params[:password])
            render json: @current_user, except: [:password_digest]
        else
            return render status: :unauthorized
        end
    end

end
