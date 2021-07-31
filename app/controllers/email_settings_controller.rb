class EmailSettingsController < ApplicationController

    def show
        @email_settings = EmailSetting.first

        if @email_settings
            render json: @email_settings
        else
            render json: {message: "No settings created yet"}, status: 404
        end
    end

    def create
        @email_settings = EmailSetting.new(email_setting_params)

        if @email_settings.save
            render json: @email_settings
        else
            render json: @email_settings.errors
        end
    end
    

    def update
        @email_settings = EmailSetting.first

        if @email_settings.update(email_setting_params)
            render json: @email_settings
        else
            render json: @email_settings.errors
        end
    end

    private
    def email_setting_params
        params.permit(:default_body, :default_subject)
    end
end
