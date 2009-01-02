class Admin::AnnouncementsController < Admin::Base

  PAGE_TITLES = { :index => 'New Announcement' }

  def new
    title_page :index
  end
  def create
    @announcement.attributes params[:announcement]
    @announcement.deliver

    redirect_to params[:return_to]
  end

  protected
  class AnnouncementPolymorphism < Polymorphism; set_namespace :admin end
  def assign_polymorphism
    @polymorphism = AnnouncementPolymorphism.new self
  end
  before_filter :assign_polymorphism
  def assign_new_announcement
    @announcement = @polymorphism.proxy_owner.announcement
  end
  before_filter :assign_new_announcement, :only => [:new, :create]

end
