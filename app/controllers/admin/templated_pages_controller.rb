class Admin::TemplatedPagesController < Admin::Base

  def new
    page.title = 'New Templated Page'
  end

  def create
    save_or_render(:new, :templated_page) { |_| render :build }
  end

  protected
  def assign_new_page
    template = Template.find params[:template_id]
    @templated_page = TemplatedPage.new do |page|
      page.template = template
      page.title = Preferences[:FarmFacts].name
      page.path = params[:path]
      page.metadata = Preferences[:FarmFacts].metadata.
          merge('author' => current_user.name)
    end
  end
  before_filter :assign_new_page, :only => [:new, :create]

end
