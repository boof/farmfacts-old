class Admin::PreviewsController < Admin::Base

  def render_textile
    string = params[:textile] || 'b. Please activate JavaScript.'
    html = ApplicationController.helpers.textile string

    render :text => html
  end

end
