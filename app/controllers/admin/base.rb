module Admin
  class AttachmentPolymorphism < Polymorphism; end

  class Base < ApplicationController; protected
    include ::Admin

    def current
      @current ||= begin
        current = super

        current.user = begin
          User.find session[:user_id]
        rescue ActiveRecord::RecordNotFound
          User.new params[:user] || {:login_attributes => {}}
        end

        current
      end
    end

    def assert_user_authorized
      raise Unauthorized unless current.user.authorized?
    end
    before_filter :assert_user_authorized

    def return_or_redirect_to(*args)
      if params[:return_to].blank? then redirect_to(*args)
      else redirect_to params[:return_to]
      end
    end

    def send_and_render(method)
      send method
      render method unless performed?
    end

    def save_or_render(method, name, *args)
      obj = instance_variable_get :"@#{ name }"
      obj.attributes = params[name]

      ActiveRecord::Base.transaction do

        if obj.save
          yield obj if block_given?
          unless performed?
            args << {:action => :index} if args.empty?
            return_or_redirect_to(*args)
          end
        else
          send_and_render method
        end

      end
    end
    
  end
end
