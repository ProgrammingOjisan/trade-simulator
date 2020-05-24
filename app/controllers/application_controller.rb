class ApplicationController < ActionController::Base
    
    include ApplicationHelper
    include ConditionsHelper
    include SessionsHelper
    
    private
    
    def require_user_logged_in
        unless logged_in?
            redirect_to login_url
        end
    end

    def require_user_logged_out
        if logged_in?
            flash[:danger] = "Please log out"
            redirect_back(fallback_location: root_path)
        end
    end
end