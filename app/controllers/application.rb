class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  filter_parameter_logging %w[password]

  protected
  def not_found(page)
    markdown = Maruku.new page.body
    render :text => markdown.to_html, :layout => true, :status => 404
  end
  def title_page(title)
    @page_title = title
  end

end
