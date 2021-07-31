class ApplicationController < ActionController::API
    include ActionController::MimeResponds

    before_action :authenticate_user, except: [:login]

    def authenticate_user
        header = request.headers["Authorization"]
        if header
            credentials = header.split(":")
            @current_user = User.find_by(name: credentials[0])

            if @current_user && @current_user.authenticate(credentials[1])
            else
                return render status: :unauthorized
            end
        else
             return render status: :unauthorized
        end
    end
end
