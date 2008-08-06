class HomeController < ApplicationController

  session :off
  caches_page :index

  def index
    @homepage = Page.find_by_name '/home'

    unless @homepage.not_found?
      @page_title = @homepage.title
    else
      redirect_to Login.count.zero?? '/setup' : login_path
    end
  end

end
