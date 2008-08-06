module Admin
  class Base < ApplicationController

    session :on

    before_filter :authorize
    helper_method :current_user

    protected
    def authorize
      unless current_user.authorized?
        session[:return_uri] = request.request_uri
        redirect_to login_path
      end
    end
    def current_user
      @__user ||= session[:user] && User.find(session[:user]) || User.new
    end
    def title_page(action, *params)
      super "Content Manager - #{ self.class.const_get(:PAGE_TITLES)[action] % params }"
    end

  end
end