module Admin
  class Base < ApplicationController
    session :on

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
      super "Content Manager - #{ self.class.const_get(:PAGE_TITLES)[action] % params }"
    end

    def clear_page_cache
      html_file_pattern = File.join Rails.root, %w[public ** *.html]
      html_files = Dir[html_file_pattern].select { |p| p !~ STATIC_HTML }
      FileUtils.rm html_files
    end

    def save_or_send(method, name, route = {:action => :index})
      obj = instance_variable_get :"@#{ name }"
      obj.attributes = params[name]

      current_user.will(:save, obj)? redirect_to(route) : send(method)
    end

  end
end
