class Admin::NavigationsController < Admin::Base

  PAGE_TITLES = {:edit => 'Navigation'}
  FILE = File.join Rails.root, %w[app views shared navigation.html]

  def edit
    title_page :edit
    @navigations = File.read FILE
  end
  def update
    File.open(FILE, 'w') { |file| file << params[:navigations] }
    clear_page_cache
    redirect_to :action => :edit
  end

end
