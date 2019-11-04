class SessionsController < ApplicationController

    def new
        render :new
    end

    def create
        user = User.find_by_credentials(params[:username], params[:password])
        if user
            session[:session_token] = user.reset_session_token!
            flash[:success] = "Logged in Successfully"
            redirect_to cats_url
        else
            flash[:error] = "Wrong email/password combo"
            render :new, status: 401
        end
    end

end