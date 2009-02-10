class ApplicationController < ActionController::Base; protected
  include ExceptionNotifiable

  helper :all
  filter_parameter_logging %w[ password ]

  def rescue_action(exception)
    case exception
    when Unauthorized
      @page_title = '401 Unauthorized'
      render_401
    else super
    end
  end

end
