class Admin::SetupController < Admin::Base

  PAGE_TITLES = { :index  => 'Setup' }

  skip_before_filter :authorize

  def index
    title_page :index
  end

  def create
  end

end
