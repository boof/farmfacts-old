class Admin::TemplatesController < Admin::Base

  def index
    page.title = 'Templates'
    @templates = Template.available.values.sort_by { |tmpl| tmpl.name }
  end

  def install
    template = Template.not_installed[ params[:id] ]
    template.try :save
    logger.debug template.errors.inspect
    return_or_redirect_to admin_templates_path
  end
  alias_method :update, :install

  def uninstall
    Template.destroy_all :name => params[:id]
    return_or_redirect_to admin_templates_path
  end
  alias_method :destroy, :uninstall

end
