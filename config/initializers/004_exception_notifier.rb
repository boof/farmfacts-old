ActionController::Base.const_set :Unauthorized, Class.new(SecurityError)

ExceptionNotifier.instance_eval do

  self.exception_recipients = SERVER_RECIPIENT
  self.sender_address       = SERVER_SENDER
  self.email_prefix         = "[#{ APPLICATION_NAME }] "

end

module ExceptionNotifiable::ClassMethods
  def exceptions_to_treat_as_401
    [ActionController::Base::Unauthorized]
  end
end

module ExceptionNotifiable

  protected
    def render_401
      respond_to do |type|
        type.html {
          @login = Login.new! :return_uri => params[:return_uri] || request.request_uri
          render :template => 'login', :layout => 'application', :status => '401 Unauthorized'
        }
        type.all  { render :nothing => true, :status => "503 Service Unavailable" }
      end
    rescue NotImplementedError
      redirect_to admin_setup_path
    end

    def render_404
      respond_to do |type|
        type.html {
          title_page Page.not_found.title
          render :text => Page.not_found.to_html, :layout => true, :status => "404 Not Found"
        }
        type.all  { render :nothing => true, :status => "404 Not Found" }
      end
    rescue ActiveRecord::RecordNotFound
      render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found"
    end

    def rescue_action_in_public(exception)
      case exception
        when *self.class.exceptions_to_treat_as_401
          render_401
        when *self.class.exceptions_to_treat_as_404
          render_404

        else          
          render_500

          deliverer = self.class.exception_data
          data = case deliverer
            when nil then {}
            when Symbol then send(deliverer)
            when Proc then deliverer.call(self)
          end

          ExceptionNotifier.deliver_exception_notification(exception, self,
            request, data)
      end
    end

end
