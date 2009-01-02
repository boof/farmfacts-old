class ApplicationController < ActionController::Base; protected
  include ExceptionNotifiable

  helper :all
  filter_parameter_logging %w[ password ]

  def title_page(title)
    @page_title = title
  end
  def last_modified(record)
    @modified_at = record.try(:updated_at) || Time.now
  end

  def rescue_action(exception)
    case exception
    when Unauthorized
      @page_title = '401 Unauthorized'
      render_401
    else super
    end
  end

end
