module Admin
  class Base < ApplicationController

    protected
    def current_user
      @__user ||= begin
        User.find session[:user_id]
      rescue ActiveRecord::RecordNotFound
        User.new
      end
    end
    helper_method :current_user

    def assert_user_authorized
      raise Unauthorized unless current_user.authorized?
    end
    before_filter :assert_user_authorized

    def title_page(action, *params)
      super self.class.const_get(:PAGE_TITLES)[action] % params
    end

    def save_or_send(method, name, route = {:action => :index})
      obj = instance_variable_get :"@#{ name }"
      obj.attributes = params[name]

      if current_user.will(:save, obj)
        yield obj if block_given?
        redirect_to route unless performed?
      else
        send method
      end
    end

  end
end
