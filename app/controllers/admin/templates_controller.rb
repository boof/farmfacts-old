class Admin::TemplatesController < Admin::Base

  def index
    page.title = 'Templates'
    @templates = Template.available.values.sort_by { |tmpl| tmpl.name }
  end

  def create
    Template.not_installed[ params[:name] ].try :save
    return_or_redirect_to admin_templates_path
  end

  def destroy
    Template.destroy_all :name => params[:name]
    return_or_redirect_to admin_templates_path
  end

end
