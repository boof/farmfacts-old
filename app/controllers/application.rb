class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  helper :all
  filter_parameter_logging %w[ password ]

  protected
  def title_page(title)
    @page_title = title
  end

end
