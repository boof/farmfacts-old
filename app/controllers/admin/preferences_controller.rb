class Admin::PreferencesController < Admin::Base

  def edit
    @module_name, @preferences = module_name, preferences

    unless @preferences
      flash[:notice] = "Module #{ @module_name } can't be configured."
      return_or_redirect_to admin_dashboard_path
    end
  end
  
  def update
    preferences.tap { |o| o.attributes = params[:preferences] }.save

    restart
    return_or_redirect_to admin_dashboard_path
  end

  protected
  def module_name
    params[:module_name]
  end
  def preferences
    Preferences[ module_name ]
  end

end
