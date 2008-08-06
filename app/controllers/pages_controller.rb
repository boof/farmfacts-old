class PagesController < ApplicationController

  caches_page :show
  helper CommentsHelper
  session :off

  def show
    @page = Page.find_by_name request.path
    title_page @page.title

    not_found(@page) if @page.not_found?
  end

end
